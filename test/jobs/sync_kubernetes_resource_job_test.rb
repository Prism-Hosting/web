require 'test_helper'

class SyncKubernetesResourceJobTest < ActiveSupport::TestCase
  test "sync kubernetes resource" do
    kubeclient.on_get_prism_server do
      Kubeclient::Resource.new({ status: { tcpProbeResponding: true, forwarding: { port: 12345 } } })
    end
    kubeclient.on_get_deployments do
      [Kubeclient::Resource.new({ spec: { replicas: 1 } })]
    end
    kubeclient.on_get_pods do
      [Kubeclient::Resource.new({ metadata: { name: "pod-black-pearl" } })]
    end
    kubeclient.on_get_pod_log do
      "#{servers(:black_pearl).logs}\n> Server ready."
    end

    SyncKubernetesResourceJob.perform_now(servers(:black_pearl))

    assert servers(:black_pearl).online?
    assert_equal "> Starting...\n> Server ready.", servers(:black_pearl).logs
  end

  test "keep logs of last boot after shutting down" do
    kubeclient.on_get_prism_server do
      Kubeclient::Resource.new({ status: { tcpProbeResponding: false, forwarding: { port: 12345 } } })
    end
    kubeclient.on_get_deployments do
      [Kubeclient::Resource.new({ spec: { replicas: 0 } })]
    end
    kubeclient.on_get_pods do
      []
    end

    SyncKubernetesResourceJob.perform_now(servers(:black_pearl))

    assert servers(:black_pearl).offline?
    assert_equal "> Starting...", servers(:black_pearl).logs
  end

  test "don't update when no changes happened" do
    kubeclient.on_get_prism_server do
      Kubeclient::Resource.new({ status: { tcpProbeResponding: true, forwarding: { port: 12345 } } })
    end
    kubeclient.on_get_deployments do
      [Kubeclient::Resource.new({ spec: { replicas: 1 } })]
    end
    kubeclient.on_get_pods do
      [Kubeclient::Resource.new({ metadata: { name: "pod-black-pearl" } })]
    end
    kubeclient.on_get_pod_log do
      servers(:black_pearl).logs
    end

    TIME = Time.parse("2050-01-01 12:00").freeze
    travel_to TIME do
      SyncKubernetesResourceJob.perform_now(servers(:black_pearl))
    end
    assert_not_equal TIME, servers(:black_pearl).updated_at
  end
end
