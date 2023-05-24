require "test_helper"

Sidekiq::Testing.fake!

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1920, 1080]

  setup do
    Sidekiq::Worker.clear_all
  end
end
