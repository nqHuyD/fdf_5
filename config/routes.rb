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
  post "/update_role", to: "user#update_role"

  resources :user
  resources :product
  resources :category, only: [:create, :update, :destroy]
  resources :cart
  resources :order
  resources :rank, only: [:create, :update]

  # Login with Facebook
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  namespace :admin do
    get "/dashboard", to: "dashboard#overview"
    get "/user_data", to: "dashboard#user_data"
    get "/category_data", to: "dashboard#category_data"
    get "/product_data", to: "dashboard#product_data"
    get "/order_data", to: "dashboard#order_data"
    post "/sort_category", to: "dashboard#sort_category"
  end
end
