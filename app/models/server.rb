class Server < ApplicationRecord
  belongs_to :user
  has_one_attached :picture do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
    attachable.variant :big, resize_to_fill: [200, 200]
  end

  validates :gslt, :name, :rcon_password, presence: true

  enum :tickrate, "64": 64, "85": 85, "100": 100, "128": 128
  enum :game_type, classic: 0, gun_game: 1, training: 2, custom: 3, cooperative: 4, skirmish: 5, free_for_all: 6
  enum :game_mode, casual: 0, competitive: 1, wingman: 2, weapons_expert: 3

  def kubernetes_name
    "prism-web-#{id}"
  end

  def to_kubernetes_resource
    Kubeclient::Resource.new(
      metadata: {
        name: kubernetes_name,
        namespace: Rails.application.config.kubenamespace
      },
      spec: {
        customer: "user-#{user.id}",
        subscriptionStart: Time.now.to_i,
        env: [
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
      }
    )
  end
end