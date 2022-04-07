# Below are the routes for madmin
namespace :madmin do
  resources :match_players
  resources :matches
  resources :players
  resources :player_stats
  resources :elo_changes
  namespace :active_storage do
    resources :attachments
  end
  namespace :active_storage do
    resources :variant_records
  end
  namespace :active_storage do
    resources :blobs
  end
  root to: "dashboard#show"
end
