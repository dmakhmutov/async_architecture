Rails.application.routes.draw do
  get "/auth/:provider/callback", to: "sessions#create"

  resource :sessions
end
