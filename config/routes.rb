Rails.application.routes.draw do
  root 'projects#index'
  resources :users, only: [:edit, :update]do
    resources :projects, only: [:index, :show]
  end
  # get 'users/project'
  # get 'users/home' => 'users#home'
  # get 'users/commit' => 'users#job'
  # patch 'users/home', :to => 'users#update', :as => :user
  devise_for :users, contollers: {cas_sessions: 'sessions'}
end
