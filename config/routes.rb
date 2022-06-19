Rails.application.routes.draw do
  draw :madmin
  namespace :api do
    resources :matches, only: [:create]
    resources :players, only: [:index] do
      post :auth, on: :collection
    end
  end

  resources :matches, only: [:index, :show]
  resources :players, only: [:index, :show] do
    get :elos_by_date, on: :collection
  end

  root to: "matches#index"
end
