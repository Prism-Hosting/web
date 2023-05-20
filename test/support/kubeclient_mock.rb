class KubeclientMock
  def initialize
    reset
  end

  def reset
    @create_prism_server_block = Proc.new { OpenStruct.new({ metadata: { uid: "TEST-UUID" } }) }
    @update_prism_server_block = Proc.new {  }
    @delete_prism_server_block = Proc.new {  }
  end

  def on_create_prism_server(&block)
    @create_prism_server_block = block
  end

  def create_prism_server(resource)
    @create_prism_server_block.call(resource)
  end

  def on_update_prism_server(&block)
    @update_prism_server_block = block
  end

  def update_prism_server(name, namespace)
    @update_prism_server_block.call(name, namespace)
  end

  def on_delete_prism_server(&block)
    @delete_prism_server_block = block
  end

  def delete_prism_server(name, namespace)
    @delete_prism_server_block.call(name, namespace)
  end
end
