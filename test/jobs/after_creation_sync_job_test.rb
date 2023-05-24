require 'test_helper'

class AfterCreationSyncJobTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "sync uuid" do
    assert_not servers(:fresh).openshift_resource_uuid

    uuid = "1111-1111-1111-1111".freeze
    kubeclient.on_get_prism_server do
      Kubeclient::Resource.new({ metadata: { labels: { custObjUuid: uuid } } })
    end

    AfterCreationSyncJob.perform_now(servers(:fresh))
    assert_equal uuid, servers(:fresh).openshift_resource_uuid
  end

  test "re-enqueue job to check again if server is starting" do
    kubeclient.on_get_prism_server do
      Kubeclient::Resource.new({ metadata: { labels: { custObjUuid: "uuid" } }, status: { tcpProbeResponding: false, forwarding: { port: 11111 } } })
    end
    kubeclient.on_get_deployments do
      [Kubeclient::Resource.new({ spec: { replicas: 1 } })]
    end
    kubeclient.on_get_pods do
      [Kubeclient::Resource.new({ metadata: { name: "pod" } })]
    end
    kubeclient.on_get_pod_log do
      "Server starting..."
    end

    assert_enqueued_with(job: AfterCreationSyncJob) do
      AfterCreationSyncJob.perform_now(servers(:fresh))
    end
  end

  test "don't re-enqueue job after server is online" do
    kubeclient.on_get_prism_server do
      Kubeclient::Resource.new({ metadata: { labels: { custObjUuid: "uuid" } }, status: { tcpProbeResponding: true, forwarding: { port: 11111 } } })
    end
    kubeclient.on_get_deployments do
      [Kubeclient::Resource.new({ spec: { replicas: 1 } })]
    end
    kubeclient.on_get_pods do
      [Kubeclient::Resource.new({ metadata: { name: "pod" } })]
    end
    kubeclient.on_get_pod_log do
      "Server started!"
    end

    assert_no_enqueued_jobs(only: AfterCreationSyncJob) do
      AfterCreationSyncJob.perform_now(servers(:fresh))
    end
  end

  # This is relevant as a user can stop the server while it's starting up.
  # So we need to cancel the more agressive sync when the user has stopped the server.
  test "don't re-enqueue job after server is offline" do
    kubeclient.on_get_prism_server do
      Kubeclient::Resource.new({ metadata: { labels: { custObjUuid: "uuid" } }, status: { tcpProbeResponding: false, forwarding: { port: 11111 } } })
    end
    kubeclient.on_get_deployments do
      [Kubeclient::Resource.new({ spec: { replicas: 0 } })]
    end
    kubeclient.on_get_pods do
      []
    end

    assert_no_enqueued_jobs(only: AfterCreationSyncJob) do
      AfterCreationSyncJob.perform_now(servers(:fresh))
    end
  end
end
