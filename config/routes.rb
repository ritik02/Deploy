Rails.application.routes.draw do
  root 'projects#index'
  resources :users, only: [:edit, :update]do
    resources :projects, only: [:index, :show]
  end
  devise_for :users, contollers: {cas_sessions: 'sessions'}
end
