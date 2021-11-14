Rails.application.routes.draw do
  get "/auth/:provider/callback", to: "sessions#create"

  resource :sessions
  resources :accounts do
    resources :transactions, only: %w(index)
  end
end
