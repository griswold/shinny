Shinny::Application.routes.draw do
  root to: "scheduled_activities#index"
  resources :rinks, only: %w( index show )
  resources :scheduled_activities, only: %w( index )
end
