Rails.application.routes.draw do
  root 'users#index'
  get 'users/index'
  devise_for :users, contollers: {cas_sessions: 'sessions'}

end
