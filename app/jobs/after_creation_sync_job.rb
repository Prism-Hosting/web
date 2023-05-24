# This job will sync the status more aggressively until the server has reached
# the "online" status.
class AfterCreationSyncJob < ApplicationJob
  def perform(server)
    # Because we have a "custObjUuid" which is added as a label some time after creating the kubernetes resource
    # we need to make sure we have this uuid set on our end, to find out what deployments/pods are relevant for us.
    unless server.openshift_resource_uuid
      prism_server = prismhosting_kubeclient.get_prism_server(server.kubernetes_name, namespace)
      server.update!(openshift_resource_uuid: prism_server.metadata.labels[:custObjUuid])
    end

    SyncKubernetesResourceJob.perform_now(server) if server.openshift_resource_uuid

    AfterCreationSyncJob.set(wait: 2.seconds).perform_later(server) unless server.online? || server.offline?
  end
end
