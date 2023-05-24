class Server < ApplicationRecord
  include Kubeclients

  belongs_to :user
  has_one_attached :picture do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
    attachable.variant :big, resize_to_fill: [200, 200]
  end

  validates :gslt, :name, :rcon_password, presence: true

  enum :tickrate, "64": 64, "85": 85, "100": 100, "128": 128
  enum :status, %i[creating starting online offline stopping]
  enum :game_type, classic: 0, gun_game: 1, training: 2, custom: 3, cooperative: 4, skirmish: 5, free_for_all: 6
  enum :game_mode, casual: 0, competitive: 1, wingman: 2, weapons_expert: 3

  broadcasts
  after_update_commit -> { broadcast_replace_later_to "server_right_actions_#{id}", partial: "servers/detail_right_actions", target: "right_actions_#{id}" }
  after_update_commit -> { broadcast_replace_later_to "server_status_badge_#{id}", partial: "servers/status_badge", target: "status_badge_#{id}" }
  after_update_commit -> { broadcast_replace_later_to "server_logs_#{id}", partial: "servers/log_container", target: "logs_#{id}" }

  scope :ordered, -> { order(:created_at) }

  def self.kubernetes_resource_to_status(prism_server, deployment)
    return self.statuses[:creating] unless prism_server.dig(:status, :forwarding, :port) && deployment

    case
    when deployment.spec.replicas == 1 && prism_server.dig(:status, :tcpProbeResponding).present?
      self.statuses[:online]
    when deployment.spec.replicas == 1 && prism_server.dig(:status, :tcpProbeResponding).blank?
      self.statuses[:starting]
    when deployment.spec.replicas == 0 && prism_server.dig(:status, :tcpProbeResponding).present?
      self.statuses[:stopping]
    else
      self.statuses[:offline]
    end
  end

  def start!
    deployment = apps_kubeclient.get_deployments(label_selector: label_selector, namespace: namespace).first
    deployment.spec.replicas = 1
    apps_kubeclient.update_deployment(deployment)
  end

  def stop!
    deployment = apps_kubeclient.get_deployments(label_selector: label_selector, namespace: namespace).first
    deployment.spec.replicas = 0
    apps_kubeclient.update_deployment(deployment)
  end

  def label_selector
    "custObjUuid=#{openshift_resource_uuid}"
  end

  def create_kubernetes_resource
    prismhosting_kubeclient.create_prism_server(to_kubernetes_resource)
  end

  def update_kubernetes_resource
    current_version = prismhosting_kubeclient.get_prism_server(kubernetes_name, namespace)
    current_version.spec.env = env_configuration
    prismhosting_kubeclient.update_prism_server(current_version)
  end

  def delete_kubernetes_resource
    prismhosting_kubeclient.delete_prism_server(kubernetes_name, namespace)
  end

  def kubernetes_name
    "#{Rails.application.config.kuberenetes_resource_prefix}-#{id}"
  end

  def to_kubernetes_resource
    Kubeclient::Resource.new(
      metadata: {
        name: kubernetes_name,
        namespace: namespace
      },
      spec: {
        customer: "user-#{user.id}",
        subscriptionStart: Time.now.to_i,
        env: env_configuration
      }
    )
  end

  def env_configuration
    [
      { name: "CSGO_HOSTNAME", value: name },
      { name: "CSGO_GSLT", value: gslt },
      { name: "CSGO_MAP", value: map },
      { name: "CSGO_PW", value: password },
      { name: "CSGO_RCON_PW", value: rcon_password },
      { name: "CSGO_TICKRATE", value: tickrate.to_s },
      { name: "CSGO_GAME_TYPE", value: read_attribute_before_type_cast(:game_type).to_s },
      { name: "CSGO_GAME_MODE", value: read_attribute_before_type_cast(:game_mode).to_s },
      { name: "CSGO_DISABLE_BOTS", value: disable_bots.to_s },
      { name: "SERVER_CONFIGS", value: server_configs.to_s },
    ]
  end

  def connect_command
    cmd = "connect #{Rails.application.config.connect_command_host}:#{port}"
    if password.present?
      cmd << "; password #{password}"
    end
    cmd
  end
end
