Rails.application.routes.draw do
  root "servers#index"

  resources :servers do
    post :start, on: :member
    post :stop, on: :member
    get :logs, on: :member
  end
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth' }
end
