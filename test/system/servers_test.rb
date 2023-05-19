require "application_system_test_case"

class ServersTest < ApplicationSystemTestCase
  setup do
    sign_in users(:jack)
    @server = servers(:black_pearl)
  end

  test "visiting the index" do
    visit servers_url
    assert_selector "h5", text: "Black Pearl Gaming Inc."
  end

  test "should create server" do
    visit servers_url
    click_on "New server"

    fill_in "Name", with: "SEL Tournament 12"
    fill_in "Password", with: "seltournament1234"
    fill_in "Steam Game Server Login Token", with: "STEAM-LOGIN-TOKEN"
    fill_in "Map", with: "de_cache"
    select "128", from: "Tickrate"
    select "Classic", from: "Game type"
    select "Competitive", from: "Game mode"
    check "Disable bots"
    check "Server configs"
    click_on "Create Server"

    assert_text "Server was successfully created"
    click_on "Back"
  end

  test "ui refreshes when updating server" do
    visit servers_url
    assert_text "Black Pearl Gaming Inc."
    assert_text "Online"

    @server.update(name: "Updated Black Pearl", status: "Offline")

    assert_text "Updated Black Pearl"
    assert_text "Offline"
  end

  # test "should update Server" do
  #   visit server_url(@server)
  #   click_on "Edit this server", match: :first

  #   check "Disable bots" if @server.disable_bots
  #   fill_in "Game mode", with: @server.game_mode
  #   fill_in "Game type", with: @server.game_type
  #   fill_in "Gslt", with: @server.gslt
  #   fill_in "Map", with: @server.map
  #   fill_in "Name", with: @server.name
  #   fill_in "Openshift resource uuid", with: @server.openshift_resource_uuid
  #   fill_in "Password", with: @server.password
  #   fill_in "Rcon password", with: @server.rcon_password
  #   check "Server configs" if @server.server_configs
  #   fill_in "Tickrate", with: @server.tickrate
  #   click_on "Update Server"

  #   assert_text "Server was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy Server" do
  #   visit server_url(@server)
  #   click_on "Destroy this server", match: :first

  #   assert_text "Server was successfully destroyed"
  # end
end
