Rails.application.routes.draw do
  get 'labels/index'
  get '/summaries/calendar'
  resources :sessions, only: %i[new create destroy]
  resources :groups
  resources :users
  resources :labels, only: %i[index create destroy]
  resources :summaries
  root 'summaries#index'

  namespace :admin do
    get '/summaries/calendar'
    resources :groups
    resources :users, only: %i[index edit show update destroy]
    resources :labels, only: %i[index create destroy]
    resources :summaries
    root 'summaries#index'
  end
end