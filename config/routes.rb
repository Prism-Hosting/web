Rails.application.routes.draw do
  root "hello#index"

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth' }
end
