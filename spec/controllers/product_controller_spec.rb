require 'rails_helper'
require "cancan/matchers"

RSpec.describe ProductController, type: :controller do
  let (:admin) {FactoryGirl.create :user, role: 0}
  let(:user) {FactoryGirl.create :user}
  let(:category) {FactoryGirl.create :category}

  describe "#index" do
    it "every User can access reading Product" do
      get :index
      is_expected.to respond_with 200
    end
  end

  describe "#create" do
    context "Guest User" do
      it "do not allow to create Product" do
        post :create, params: {product: {
          name: "Pizza",
          inventory: 15,
          description: "Delicious",
          price: 2
        }}
        is_expected.to redirect_to root_path
      end
    end

    context "Normal User" do
      before {sign_in user}
      it "do not allow to create Product" do
        post :create, params: {product: {
          name: "Pizza",
          inventory: 15,
          description: "Delicious",
          price: 2
        }}
        is_expected.to redirect_to root_path
      end
    end

    context "Admin User" do
      before {sign_in admin}
      it "allow to create Product" do
        category
        session[:category_product] = [category.id]
        post :create, params: {product: {
          name: "Pizza",
          inventory: 15,
          description: "Delicious",
          price: 2,
          category_product: 2,
          food_images: ["url"]
        }, format: :js}
        expect(response.body).to match "/admin/product_data"
      end

      it "can not create Product when transaction error happen" do
        session[:category_product] = 1
        post :create, params: {product: {
          name: "Pizza",
          inventory: 15,
          description: "Delicious",
          price: 2,
          category_product: 2,
          food_images: ["url"]
        }, format: :js}
        is_expected.to render_template "product/errors_transaction.js.erb"
      end

      it "can not create Product when food_image or category nil" do
        post :create, params: {product: {
          name: "Pizza",
          inventory: 15,
          description: "Delicious",
          price: 2,
          category_product: 2
        }, format: :js}
        is_expected.to render_template "product/category_missing.js.erb"
      end
    end
  end

  describe "#show" do
    it "every User can access show Product" do
      get :show, params: {id: 1}
      is_expected.to respond_with 200
    end

    it "can not assess when product is nil" do
      get :show, params: {id: 0}
      is_expected.to render_template "user/errorFind"
    end
  end

  describe "#category" do
    it "loading success category" do
      category
      post :category, params: {category: category.id, rank: 5}, format: :js
      is_expected.to respond_with 200
    end
  end

  describe "#filter" do
    it "loading success category" do
      category
      post :filter, params: {filter: 1}, format: :js
      is_expected.to respond_with 200
    end
  end

  describe "#range_price" do
    it "loading success category" do
      post :range_price, format: :js
      is_expected.to render_template "product/category.js.erb"
    end
  end

  describe "#pagination" do
    it "loading success pagination" do
      post :pagination, params: {
        category: category.id,
        current_page: 1,
        filter: 1,
        rank: 0
      },
      format: :js
      is_expected.to render_template "product/filter.js.erb"
    end
  end

  describe "#rank" do
    it "loading success rank filter" do
      post :rank, params: {rank: 0}, format: :js
      is_expected.to render_template "product/category.js.erb"
    end
  end
end
