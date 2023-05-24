class KubeclientMock
  def initialize
    reset
  end

  def reset
    @create_prism_server_block = Proc.new {  }
    @get_prism_server_block = Proc.new { Kubeclient::Resource.new({ metadata: { labels: { custObjUuid: "sample-uuid" } }, spec: { env: [] } }) }
    @get_deployments_block = Proc.new { Kubeclient::Resource.new({ spec: { replicas: [] } }) }
    @get_pods_block = Proc.new { Kubeclient::Resource.new({ metadata: { name: [] } }) }
    @get_pod_log_block = Proc.new { "> Sample logs\n> Starting server..." }
    @update_prism_server_block = Proc.new {  }
    @delete_prism_server_block = Proc.new {  }
  end

  def on_create_prism_server(&block)
    @create_prism_server_block = block
  end

  def create_prism_server(resource)
    @create_prism_server_block.call(resource)
  end

  def on_get_prism_server(&block)
    @get_prism_server_block = block
  end

  def get_prism_server(name, namespace)
    @get_prism_server_block.call(name, namespace)
  end

  def on_update_prism_server(&block)
    @update_prism_server_block = block
  end

  def update_prism_server(resource)
    @update_prism_server_block.call(resource)
  end

  def on_delete_prism_server(&block)
    @delete_prism_server_block = block
  end

  def delete_prism_server(name, namespace)
    @delete_prism_server_block.call(name, namespace)
  end

  def on_get_deployments(&block)
    @get_deployments_block = block
  end

  def get_deployments(*args, **kwargs)
    @get_deployments_block.call(*args, **kwargs)
  end

  def on_get_pods(&block)
    @get_pods_block = block
  end

  def get_pods(*args, **kwargs)
    @get_pods_block.call(*args, **kwargs)
  end

  def on_get_pod_log(&block)
    @get_pod_log_block = block
  end

  def get_pod_log(*args, **kwargs)
    @get_pod_log_block.call(*args, **kwargs)
  end
end
