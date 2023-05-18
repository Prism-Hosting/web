class KubeclientMock
  def initialize
    reset
  end

  def reset
    @create_prism_server_block = Proc.new { OpenStruct.new({ metadata: { uid: "TEST-UUID" } }) }
  end

  def on_create_prism_server(&block)
    @create_prism_server_block = block
  end

  def create_prism_server(resource)
    @create_prism_server_block.call(resource)
  end
end
