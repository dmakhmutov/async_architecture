Rails.application.routes.draw do
  root "tasks#index"

  get "/auth/:provider/callback", to: "sessions#create"

  resource :sessions

  resources :tasks
  resources :self_tasks, only: %i(index update)
  resource :reassign, only: %i(create)
end
