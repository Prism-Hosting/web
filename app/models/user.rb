class User < ApplicationRecord
  has_many :servers
  devise :omniauthable, :trackable, :database_authenticatable, :rememberable

  def self.create_from_provider_data(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.username = auth.info.nickname
      user.email = "#{auth.info.nickname}@omniauth.steam.com"
      user.password = Devise.friendly_token[0, 20]
      user.image_url = auth.info.image
    end
  end
end
