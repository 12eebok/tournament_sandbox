TournamentSandbox::Application.routes.draw do

  resources :teams

  namespace :competitive do
    resources :registrations do
      collection do
        post :sample_registrations
      end
    end
  end

  resources :competitions do
    member do
      get :results
      get :generate_graph
    end
  end

  resources :matches

  resources :eliminations

  resources :games

  resources :tournaments do
    collection do
      post :send_broadcast
      get :results
      get :archive
      get :calendar
      get :leaderboard
    end
  end


  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end