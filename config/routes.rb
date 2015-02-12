PostitTemplate::Application.routes.draw do
  root to: 'posts#index'
  resources :posts, except: [:destroy] do
    resources :comments, only: [:create]
  end
  resources :categories, only: [:show, :new, :create]

  # Create a new user
    get '/register', to: 'users#new'
    resources :users, except: [:new]

  # Sessions Resources
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    get '/logout', to: 'sessions#destroy'
end
