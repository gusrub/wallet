Rails.application.routes.draw do
  resources :users, constraints: { format: 'json' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'versions#index'
end
