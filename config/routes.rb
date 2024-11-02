Rails.application.routes.draw do
  devise_for :users
  
  resources :cards
  
  # Route for viewing a specific user's collection
  get 'users/:user_id/cards', to: 'cards#index', as: 'user_cards'
  
  root 'cards#index'
end
