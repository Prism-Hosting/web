# This job will synchronise the status, port and logs of the kubernetes cluster
# into our database.
class SyncKubernetesResourceJob < ApplicationJob
  def perform(server, force_update: false)
    prism_server = prismhosting_kubeclient.get_prism_server(server.kubernetes_name, namespace)
    deployment = apps_kubeclient.get_deployments(label_selector: server.label_selector, namespace: namespace).first
    pod = kubeclient.get_pods(label_selector: server.label_selector, field_selector: "status.phase=Running", namespace: namespace).first

    port = prism_server.dig(:status, :forwarding, :port)
    status = Server.kubernetes_resource_to_status(prism_server, deployment)
    server.assign_attributes(status: status, port: port)
    server.logs = kubeclient.get_pod_log(pod.metadata.name, namespace) if pod
    server.save! if server.changed? || force_update
  end
end
