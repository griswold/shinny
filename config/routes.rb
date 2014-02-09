Shinny::Application.routes.draw do
  root to: "rinks#index"
  resources :rinks
end
