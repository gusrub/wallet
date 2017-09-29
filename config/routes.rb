Rails.application.routes.draw do
  resources :tokens, constraints: { format: 'json' }, only: [:create, :show]
  resources :fees, constraints: { format: 'json' }
  resources :users, constraints: { format: 'json' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'versions#index'
end
