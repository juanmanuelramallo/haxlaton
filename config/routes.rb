Rails.application.routes.draw do
  namespace :api do
    resources :matches, only: [:create]
  end
end
