Rails.application.routes.draw do
  draw :madmin
  namespace :api do
    resources :matches, only: [:create]
    resources :players, only: [:index]
  end

  resources :matches, only: [:index, :destroy, :show]
  resources :players, only: [:index, :show] do
    get :elos_by_date, on: :collection
  end

  root to: "matches#index"
end
