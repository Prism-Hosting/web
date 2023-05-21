class KubeclientMock
  def initialize
    reset
  end

  def reset
    @create_prism_server_block = Proc.new { OpenStruct.new({ metadata: { uid: "TEST-UUID" } }) }
    # Using JSON.parse with OpenStruct will allow access of foo.bar.baz and not only the first level
    @get_prism_server_block = Proc.new { |_name, _namespace| JSON.parse({ spec: { env: [] } }.to_json, object_class: OpenStruct) }
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
end
