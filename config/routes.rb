TournamentSandbox::Application.routes.draw do

  resources :teams


  namespace :competitive do
    resources :registrations do
      collection do
        post :sample_registrations
      end
    end
  end


  resources :competitions


  resources :matches


  resources :games


  resources :tournaments do
    collection do
      post :send_broadcast
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