def generate_kubernetes_client(api, version = "v1", **override_options)
  options = {
    auth_options: {
      bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token'
    },
    ssl_options: {
      ca_file: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
    }
  }.merge(override_options)
  Kubeclient::Client.new(
    api,
    version,
    **options
  )
end


if Rails.env.production? && ENV["SECRET_KEY_BASE"] != "buildingassets"
  Rails.application.config.kubenamespace = File.read('/var/run/secrets/kubernetes.io/serviceaccount/namespace')
  # See https://github.com/ManageIQ/kubeclient/issues/369#issuecomment-1556217934
  # tl;dr You need to make a separate client per api you want to use. :cry:
  Rails.application.config.prismhosting_kubeclient = generate_kubernetes_client('https://kubernetes.default.svc/apis/prism-hosting.ch')
  Rails.application.config.apps_kubeclient = generate_kubernetes_client('https://kubernetes.default.svc/apis/apps')
  Rails.application.config.kubeclient = generate_kubernetes_client('https://kubernetes.default.svc/api')
elsif Rails.env.development?
  options = {
    auth_options: {
      bearer_token: Rails.application.credentials.openshift_development_token || ENV["KUBECLIENT_TOKEN"]
    },
    ssl_options: {
      verify_ssl: OpenSSL::SSL::VERIFY_NONE
    }
  }
  Rails.application.config.kubenamespace = ENV.fetch("KUBECLIENT_NAMESPACE", "prism-servers")
  Rails.application.config.prismhosting_kubeclient = generate_kubernetes_client('https://api.openshift.androme.da:6443/apis/prism-hosting.ch', **options)
  Rails.application.config.apps_kubeclient = generate_kubernetes_client('https://api.openshift.androme.da:6443/apis/apps', **options)
  Rails.application.config.kubeclient = generate_kubernetes_client('https://api.openshift.androme.da:6443/api', **options)
else
  require_relative "../../test/support/kubeclient_mock"
  Rails.application.config.kubenamespace = "test"
  mock = KubeclientMock.new
  Rails.application.config.kubeclient = mock
  Rails.application.config.prismhosting_kubeclient = mock
  Rails.application.config.apps_kubeclient = mock
end
