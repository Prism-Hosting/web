require "test_helper"

class ServerTest < ActiveSupport::TestCase
  test "to_kubernetes_resource" do
    fixed_timestamp = 1672527600
    travel_to Time.at(fixed_timestamp) do
      assert_equal(
        {
          metadata: {
            name: "prism-web-#{servers(:black_pearl).id}",
            namespace: Rails.application.config.kubenamespace
          },
          spec: {
            customer: "user-#{users(:jack).id}",
            subscriptionStart: fixed_timestamp,
            env: [
              { name: "CSGO_HOSTNAME", value: "Black Pearl Gaming Inc." },
              { name: "CSGO_GSLT", value: "12345678" },
              { name: "CSGO_MAP", value: "de_inferno" },
              { name: "CSGO_PW", value: "seltournament1234" },
              { name: "CSGO_RCON_PW", value: "seladmin42$2$" },
              { name: "CSGO_TICKRATE", value: "128" },
              { name: "CSGO_GAME_TYPE", value: "0" },
              { name: "CSGO_GAME_MODE", value: "1" },
              { name: "CSGO_DISABLE_BOTS", value: "true" },
              { name: "SERVER_CONFIGS", value: "true" },
            ]
          }
        },
        servers(:black_pearl).to_kubernetes_resource.to_h)
    end
  end
end