Rails.application.routes.draw do
  root 'projects#index'
  resources :users, only: [:edit, :update]do
    resources :projects, only: [:index, :show] do
      resources :commits, only: [:index, :show]
    end
  end
  resources :deployments, only: [:new, :create]
  devise_for :users, contollers: {cas_sessions: 'sessions'}
end
