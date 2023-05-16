if Rails.env.production? && ENV["SECRET_KEY_BASE"] != "buildingassets"
  Rails.application.config.kubenamespace = File.read('/var/run/secrets/kubernetes.io/serviceaccount/namespace')
  Rails.application.config.kubeclient = Kubeclient::Client.new(
    'https://kubernetes.default.svc/apis/prism-hosting.ch',
    'v1',
    auth_options: {
      bearer_token_file: '/var/run/secrets/kubernetes.io/serviceaccount/token'
    },
    ssl_options: {
      ca_file: '/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
    }
  )
else
  Rails.application.config.kubenamespace = ENV.fetch("KUBECLIENT_NAMESPACE", "prism-servers")
  Rails.application.config.kubeclient = Kubeclient::Client.new(
    ENV.fetch("KUBECLIENT_URL", "https://api.openshift.androme.da:6443/apis/prism-hosting.ch"),
    'v1',
    auth_options: {
      bearer_token: Rails.application.credentials.openshift_development_token || ENV["KUBECLIENT_TOKEN"]
    },
    ssl_options: {
      verify_ssl: OpenSSL::SSL::VERIFY_NONE
    }
  )
end
