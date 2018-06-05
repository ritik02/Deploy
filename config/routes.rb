Rails.application.routes.draw do
  root 'users#project'
  get 'users/project'
  get 'users/home' => 'users#home'
  get 'users/job' => 'users#job'
  patch 'users/home', :to => 'users#update', :as => :user
  devise_for :users, contollers: {cas_sessions: 'sessions'}

end
