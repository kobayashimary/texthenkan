Rails.application.routes.draw do

  root to: 'toppages#index'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'signup', to: 'users#new'
 resources :users, only: [:index, :new, :create,:edit,:update,:destroy] do
    member do
      get :documents_ichiran
    end
  end
 resources :documents, only: [:show, :new, :create,:edit,:update,:destroy]
 resources :translations, only: [:new,:create,:edit,:update,:destroy]
end
