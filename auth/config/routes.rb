Rails.application.routes.draw do
  use_doorkeeper
  devise_for :accounts, controllers: { registrations: "registrations" }

  root "accounts#index"

  resources :accounts do
    get :me, on: :collection
  end
end
