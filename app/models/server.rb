class Server < ApplicationRecord
  belongs_to :user
  has_one_attached :picture do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
    attachable.variant :big, resize_to_fill: [200, 200]
  end

  validates :gslt, :name, :rcon_password, presence: true

  enum :tickrate, "64": 64, "85": 85, "100": 100, "128": 128
  enum :game_type, classic: 0, gun_game: 1, training: 2, custom: 3, cooperative: 4, skirmish: 5, free_for_all: 6
  enum :game_mode, casual: 0, competitive: 1, wingman: 2, weapons_expert: 3
end
