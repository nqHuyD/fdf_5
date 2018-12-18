Rails.application.routes.draw do
  root "static_pages#home"

  get "/about", to: "static_pages#about", as: "about"
  get "/mail" , to: "static_pages#mail", as: "mail"

  resources :user
end
