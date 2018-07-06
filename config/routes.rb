Rails.application.routes.draw do
  root 'projects#index'
  devise_for :users, contollers: {cas_sessions: 'sessions'}
  get 'deployments/:id/trigger_deployment', to: 'deployments#trigger_deployment', as: 'trigger_deployment'
  get 'users/:id/admin', to: 'users#make_admin', as: 'make_admin'
  resources :users, only: [:edit, :update, :index, :show]do
    resources :projects, only: [:index, :show] do
      resources :commits, only: [:index, :show]
    end
  end
  resources :deployments, only: [:new, :create, :index, :show, :update]
end
