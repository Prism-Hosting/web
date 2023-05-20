require "test_helper"

class ServersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:jack)
    @server = servers(:black_pearl)
  end

  test "should get index" do
    get servers_url
    assert_response :success
  end

  test "should get new" do
    get new_server_url
    assert_response :success
  end

  test "should create server" do
    assert_difference("Server.count") do
      post servers_url, params: { server: { disable_bots: @server.disable_bots, game_mode: @server.game_mode, game_type: @server.game_type, gslt: @server.gslt, map: @server.map, name: @server.name, password: @server.password, rcon_password: @server.rcon_password, server_configs: @server.server_configs, tickrate: @server.tickrate } }
    end

    assert_redirected_to server_url(Server.last)
  end

  test "should not create server when kubernetes API fails" do
    Rails.application.config.kubeclient.on_create_prism_server do |_|
      raise "Kubernetes API errored"
    end

    assert_no_difference("Server.count") do
      assert_raises do
        post servers_url, params: { server: { name: "Test", gslt: "TEST-TOKEN", rcon_password: "pw" } }
      end
    end
  end

  test "should show server" do
    get server_url(@server)
    assert_response :success
  end

  test "should update server" do
    patch server_url(@server), params: { server: { disable_bots: @server.disable_bots, game_mode: @server.game_mode, game_type: @server.game_type, gslt: @server.gslt, map: @server.map, name: @server.name, openshift_resource_uuid: @server.openshift_resource_uuid, password: @server.password, rcon_password: @server.rcon_password, server_configs: @server.server_configs, tickrate: @server.tickrate } }
    assert_redirected_to server_url(@server)
  end

  test "should destroy server" do
    assert_difference("Server.count", -1) do
      delete server_url(@server)
    end

    assert_redirected_to servers_url
  end
end
