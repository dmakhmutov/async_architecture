Rails.application.routes.draw do
  root "accounts#index"
  get "/auth/:provider/callback", to: "sessions#create"

  resource :sessions
  resources :accounts do
    resources :transactions, only: %w(index)
  end

  resource :pay_money, only: :create
end
