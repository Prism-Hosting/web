class CreateServers < ActiveRecord::Migration[7.0]
  def change
    create_table :servers do |t|
      t.string :openshift_resource_uuid
      t.string :name, null: false
      t.string :gslt, null: false
      t.string :map, default: "de_dust2"
      t.string :password
      t.string :rcon_password, null: false
      t.integer :tickrate, null: false, default: 128
      t.integer :game_type, null: false, default: 0
      t.integer :game_mode, null: false, default: 1
      t.boolean :disable_bots, default: false
      t.boolean :server_configs, default: true
      t.belongs_to :user, foreign_key: { force: :cascade }, null: false

      t.timestamps
    end
  end
end
