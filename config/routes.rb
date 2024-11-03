Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  resources :cards do
    member do
      post 'toggle_want'
    end
  end
  
  # Route for viewing a specific user's collection
  get 'users/:user_id/cards', to: 'cards#index', as: 'user_cards'
  
  get 'my_wants', to: 'cards#my_wants'
  
  root 'cards#index'

  namespace :admin do
    get '/', to: 'admin#dashboard'
    get 'pending_users', to: 'admin#pending_users'
    get 'rejected_users', to: 'admin#rejected_users'
    get 'approved_users', to: 'admin#approved_users'
    get 'whitelist', to: 'admin#whitelist'
    post 'approve_user/:id', to: 'admin#approve_user', as: :approve_user
    post 'reject_user/:id', to: 'admin#reject_user', as: :reject_user
    post 'whitelist', to: 'admin#add_to_whitelist'
    delete 'whitelist/:id', to: 'admin#remove_from_whitelist', as: :remove_from_whitelist
  end

  get 'pending_approval', to: 'pages#pending_approval'
end
