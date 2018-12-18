Rails.application.routes.draw do
  root "static_pages#home"

  get "/about", to: "static_pages#about", as: "about"
  get "/mail" , to: "static_pages#mail", as: "mail"
  post "/singup", to: "user#create", as: "signup"
  post "/sessions", to: "sessions#create", as: "sessions"
  delete "/logout", to: "sessions#destroy", as: "logout"
  post "/product/category", to: "product#category"
  post "/product/filter", to: "product#filter"
  post "/product/range_price", to: "product#range_price"
  post "/product/pagination", to: "product#pagination"
  post "/neworder", to: "order#create"
  post "/reset_star", to: "rank#reset_star"
  post "/product/rank", to: "product#rank"

  resources :user
  resources :product
  resources :cart
  resources :order
  resources :rank, only: [:create, :update]

  namespace :admin do
    get "/dashboard", to: "dashboard#home"
  end
end
