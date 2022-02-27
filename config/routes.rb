Rails.application.routes.draw do
  namespace :api do
    resources :matches, only: [:create]
  end

  resources :matches, only: [:index]

  root to: "matches#index"
end
