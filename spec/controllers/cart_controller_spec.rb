require 'rails_helper'
require "cancan/matchers"

RSpec.describe CartController, type: :controller do
  let(:product) {FactoryGirl.create :product, inventory: 10}
  let (:admin) {FactoryGirl.create :user, role: 0, phone: "0935722000"}
  let(:user) {FactoryGirl.create :user}
  let(:symid) {"cartno_" + user.id.to_s}
  let(:symquantity) {"cartquantity_" + user.id.to_s}


  describe "#index" do
    it "every user can access index" do
      get :index
      is_expected.to respond_with 200
    end
  end

  describe "#create" do
    context "Guest User" do
      it "not allow to create cart" do
        post :create, params: {
          product_id: product.id,
          quantity: 2
        }, format: :js
        is_expected.to redirect_to root_path
      end
    end

    context "Normal User" do
      before {sign_in user}
      it "allow to create cart" do
        post :create, params: {
          product_id: product.id,
          quantity: 2
        }, format: :js
        is_expected.to render_template "cart/create"
      end

      it "allow to update cart" do
        cookies.permanent.signed[symid.to_sym] = product.id.to_s + ","
        cookies.permanent[symquantity.to_sym] = 2.to_s + ","
         post :create, params: {
          product_id: product.id,
          quantity: 2
        }, format: :js
        is_expected.to render_template "cart/create"
      end
    end
  end

  describe "#update" do
    context "Guest User" do
      it "not allow to update cart" do
        post :update, params: {newVal: 2, id: product.id}, format: :js
        is_expected. to redirect_to root_path
      end
    end

    context "Normal User" do
      before {sign_in user}
      it "allow to update cart" do
        cookies.permanent.signed[symid.to_sym] = product.id.to_s + ","
        cookies.permanent[symquantity.to_sym] = 2.to_s + ","
        post :update, params: {newVal: 4, id: product.id}, format: :js
        is_expected.to render_template "cart/update"
      end
    end
  end

  describe "#destroy" do
    context "Guest User" do
      it "not allow to destroy cart" do
        delete :destroy, params: {
          id: product.id
        }
        is_expected.to redirect_to root_path
      end
    end

    context "Normal User" do
      before {sign_in user}
      it "not allow to destroy cart" do
        delete :destroy, params: {
          id: product.id
        }
        is_expected.to redirect_to root_path
      end
    end

    context "Admin User" do
      before {sign_in admin}
      it "allow to destroy cart" do
        symid = "cartno_" + admin.id.to_s
        symquantity = "cartquantity_" + admin.id.to_s
        cookies.permanent.signed[symid.to_sym] = product.id.to_s + ","
        cookies.permanent[symquantity.to_sym] = 2.to_s + ","
        delete :destroy, params: {
          id: product.id
        }, format: :js
        is_expected.to render_template "cart/destroy"
      end
    end
  end
end
