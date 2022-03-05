Rails.application.routes.draw do
  namespace :api do
    resources :matches, only: [:create]
    resources :players, only: [:index]
  end

  resources :matches, only: [:index, :destroy]
  resources :players, only: [:index]

  root to: "matches#index"
end
