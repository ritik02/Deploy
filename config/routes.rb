Rails.application.routes.draw do
  root 'projects#index'
  get 'deployments/:id/trigger_deployment', to: 'deployments#trigger_deployment', as: 'trigger_deployment'
  resources :users, only: [:edit, :update, :index]do
    resources :projects, only: [:index, :show] do
      resources :commits, only: [:index, :show]
    end
  end
  resources :deployments, only: [:new, :create, :index, :show, :update]
  devise_for :users, contollers: {cas_sessions: 'sessions'}
end
