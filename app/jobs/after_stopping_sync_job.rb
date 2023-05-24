# This job will sync the status more aggressively until the server has reached
# the "offline" status.
class AfterStoppingSyncJob < ApplicationJob
  def perform(server)
    SyncKubernetesResourceJob.perform_now(server)

    AfterStoppingSyncJob.set(wait: 2.seconds).perform_later(server) unless server.offline?
  end
end
