Rails.application.routes.draw do
  root "servers#index"

  resources :servers
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth' }
end
