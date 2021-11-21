Rails.application.routes.draw do
  root "dashboards#index"
  get "/auth/:provider/callback", to: "sessions#create"

  resource :sessions
end
