require "resque/server"

Rails.application.routes.draw do
  mount Resque::Server.new, :at => "/resque"
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

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

  resources :user, only: :destroy
  resources :product, only: [:create, :show, :index]
  resources :category, only: [:create, :update, :destroy]
  resources :cart
  resources :order
  resources :rank, only: [:create, :update]

  # Login with Facebook
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  namespace :admin do
    get "/notify_data", to: "dashboard#notify_data"
    get "/dashboard", to: "dashboard#overview"
    get "/user_data", to: "dashboard#user_data"
    get "/category_data", to: "dashboard#category_data"
    get "/product_data", to: "dashboard#product_data"
    get "/order_data", to: "dashboard#order_data"
    post "/sort_category", to: "dashboard#sort_category"
    post "/update_category/:id", to: "dashboard#update_category"
    post "/type_product_choice", to: "dashboard#type_product_choice"

    # Update Activities Read Field
    post "/update_activites", to: "dashboard#update_activites"
    # Update Active Status
    patch "/active_update_category/:id", to: "dashboard#active_update_category"
    patch "/active_update_products/:id", to: "dashboard#active_update_products"
    patch "/active_update_users/:id", to: "dashboard#active_update_users"

    get "/category_product_option/:type",
      to: "dashboard#category_product_option"
    get "/category_product_append/:category",
      to: "dashboard#category_product_append"
    delete "/category_product_destroy/:category",
      to: "dashboard#category_product_destroy"
    delete "/product_destroy/:id",
      to: "dashboard#product_destroy"
    patch "/update_product/:id",
      to: "dashboard#update_product", as: "admin_update_product"
  end
end
