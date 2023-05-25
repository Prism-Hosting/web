class SyncAllServersJob < ApplicationJob
  def perform
    Server.where.not(openshift_resource_uuid: nil).each do |server|
      SyncKubernetesResourceJob.perform_later(server)
    end
  end
end
