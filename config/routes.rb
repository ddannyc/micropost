Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  root 'posts#index'
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#oauth'

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :albums
  resources :photos,               only: [:create, :destroy]
  resources :categories,          only: [:create, :destroy]
  resources :posts

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
