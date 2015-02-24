PostitTemplate::Application.routes.draw do
  root to: 'posts#index'
  resources :posts, except: [:destroy] do
    resources :comments, only: [:create] do
      post 'vote', on: :member
    end
    post 'vote', on: :member
  end
  resources :categories, only: [:show, :new, :create]

  # Create a new user
    get '/register', to: 'users#new'
    resources :users, only: [:show, :edit, :create, :update]

  # Sessions Resources
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    get '/logout', to: 'sessions#destroy'
    get '/twofactor', to: 'sessions#twofactor'
    post '/twofactor', to: 'sessions#twofactor'
end
