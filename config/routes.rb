Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :users, except: [:new, :edit]
    resources :companies, except: [:new, :edit]
    resources :flights, except: [:new, :edit]
    resources :bookings, except: [:new, :edit]
    post '/session', to: 'sessions#create'
    delete '/session', to: 'sessions#destroy'
    # resource :session, only: [:create, :destroy]

    namespace :statistics do
      get '/flights', to: 'flights#index'
      get '/companies', to: 'companies#index'
    end
  end
  get '/world-cup', to: 'application#world_cup'
end
