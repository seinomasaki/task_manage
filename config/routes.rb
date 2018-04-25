Rails.application.routes.draw do
  root 'summaries#index'
  resources :summaries
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
