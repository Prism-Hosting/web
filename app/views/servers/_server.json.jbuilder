json.extract! server, :id, :name, :gslt, :map, :password, :rcon_password, :tickrate, :game_type, :game_mode, :disable_bots, :server_configs, :created_at, :updated_at
json.url server_url(server, format: :json)
