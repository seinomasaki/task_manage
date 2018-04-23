Rails.application.routes.draw do
  root "summaries#summary"
  resources :summaries
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
