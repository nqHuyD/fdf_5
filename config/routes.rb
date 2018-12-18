Rails.application.routes.draw do
  root "static_pages#home"

  get "/about", to: "static_pages#about", as: "about"
  get "/mail" , to: "static_pages#mail", as: "mail"
  post "/singup", to: "user#create", as: "signup"
  post "/session", to: "session#create", as: "session"
  delete "/logout", to: "session#destroy", as: "logout"
  post "/product/category", to: "product#category"
  post "/product/filter", to: "product#filter"
  post "/product/range_price", to: "product#range_price"
  post "/product/pagination", to: "product#pagination"

  resources :user
  resources :product
  resources :cart
end
