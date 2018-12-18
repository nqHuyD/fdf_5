Rails.application.routes.draw do
  root "static_pages#home"

  get "/about", to: "static_pages#about", as: "about"
  get "/mail" , to: "static_pages#mail", as: "mail"
  post "/singup", to: "user#create", as: "signup"
  post "/sessions", to: "sessions#create", as: "sessions"

  delete "/logout", to: "sessions#destroy", as: "logout"

  resources :user
end
