Rails.application.routes.draw do
  root to: 'versions#index'

  resources :tokens, constraints: { format: 'json' }, only: [:create, :show]
  resources :fees, constraints: { format: 'json' }
  resources :users, constraints: { format: 'json' } do
    resources :cards, except: :update
  end
end
