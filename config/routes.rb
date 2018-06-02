Rails.application.routes.draw do
  root 'users#index'
  get 'users/index'
  get 'users/home'
  devise_for :users, contollers: {cas_sessions: 'sessions'}

end
