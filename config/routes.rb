Rails.application.routes.draw do
  resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show"



  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "tasks#index"
end
#######
#URL             →  Controller#Action  →  View file
─────────────────────────────────────────────────────
#/               →  tasks#index        →  app/views/tasks/index.html.erb
#/tasks          →  tasks#index        →  app/views/tasks/index.html.erb
#/tasks/new      →  tasks#new          →  app/views/tasks/new.html.erb
#/tasks/:id      →  tasks#show         →  app/views/tasks/show.html.erb
#/tasks/:id/edit →  tasks#edit         →  app/views/tasks/edit.html.erb


#######
#Controller#Action   →   app/views/[controller]/[action].html.erb

#tasks#index         →   app/views/tasks/index.html.erb
#tasks#show          →   app/views/tasks/show.html.erb
#tasks#new           →   app/views/tasks/new.html.erb

#