Rails.application.routes.draw do
  devise_for :users
  
  resources :cards do
    member do
      post 'toggle_want'
    end
  end
  
  # Route for viewing a specific user's collection
  get 'users/:user_id/cards', to: 'cards#index', as: 'user_cards'
  
  get 'my_wants', to: 'cards#my_wants'
  
  root 'cards#index'
end
