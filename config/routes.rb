Rails.application.routes.draw do
  get  "profile",      to: "profile#show",   as: :profile
  get  "profile/edit", to: "profile#edit",   as: :edit_profile
  patch "profile",     to: "profile#update"
  resources :tasks
  get "up" => "rails/health#show"
  root "tasks#index"
end
