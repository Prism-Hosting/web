module Kubeclients
  def namespace
    Rails.application.config.kubenamespace
  end

  def prismhosting_kubeclient
    Rails.application.config.prismhosting_kubeclient
  end

  def apps_kubeclient
    Rails.application.config.apps_kubeclient
  end

  def kubeclient
    Rails.application.config.kubeclient
  end
end
