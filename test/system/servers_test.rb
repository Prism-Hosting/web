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

    @server.update(name: "Updated Black Pearl", status: "offline")

    assert_text "Updated Black Pearl"
    assert_text "Offline"
  end

  test "detail page actions and badge refreshes" do
    visit @server

    assert_text "Online"
    assert_text "Stop"

    @server.offline!

    assert_text "Offline"
    assert_text "Start"
  end

  test "should destroy Server" do
    visit advanced_server_url(@server)
    assert find('[type="submit"]').disabled?
    fill_in :name, with: @server.name

    assert_difference "Server.count", -1 do
      click_on "Delete"
      assert_text "Server was successfully destroyed"
    end
  end
end
