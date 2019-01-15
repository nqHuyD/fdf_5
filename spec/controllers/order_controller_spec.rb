require 'rails_helper'
require "cancan/matchers"

RSpec.describe OrderController, type: :controller do
  let (:admin) {FactoryGirl.create :user, role: 0, phone: "0935732120"}
  let(:user) {FactoryGirl.create :user}
  let(:product) {FactoryGirl.create :product, inventory: 10}
  let(:order) {FactoryGirl.create :order, user_id: user.id}
  let(:symid) {"cartno_" + user.id.to_s}
  let(:symquantity) {"cartquantity_" + user.id.to_s}

  describe "#index" do
    context "Guest User" do
      it "do not allow to acces" do
        get :index
        is_expected.to redirect_to root_path
      end
    end

    context "Normal User" do
      before {sign_in user}
      it "allow to acces" do
        get :index
        is_expected.to respond_with 200
      end
    end

    context "Admin User" do
      before {sign_in admin}
      it "allow to acces" do
        get :index
        is_expected.to respond_with 200
      end
    end
  end

  describe "#create" do
    context "Guest User" do
      it "do not allow to create" do
        get :create, params: {order: {
          name: nil,
          phone: nil,
          address: nil
        }}, format: :js
        is_expected.to redirect_to root_path
      end
    end

    context "Normal User" do
      before {sign_in user}
      it "allow to create" do
        cookies.permanent.signed[symid.to_sym] = product.id.to_s + ","
        cookies.permanent[symquantity.to_sym] = 2.to_s + ","
        post :create, params: {order: {
          name: user.name,
          phone: user.phone,
          address: "48 Phan Chau Trinh"
        }}, format: :js
        is_expected.to redirect_to cart_index_path
      end

      it "not allow to order when cart is empty" do
        post :create, params: {order: {
          name: user.name,
          phone: user.phone,
          address: "48 Phan Chau Trinh"
        }}, format: :js
        is_expected.to render_template "order/empty.js.erb"
      end

      it "not allow to order when the number cart bigger than inventory" do
        cookies.permanent.signed[symid.to_sym] = product.id.to_s + ","
        cookies.permanent[symquantity.to_sym] = 12.to_s + ","
        post :create, params: {order: {
          name: user.name,
          phone: user.phone,
          address: "48 Phan Chau Trinh"
        }}, format: :js
        is_expected.to render_template "order/errorlist.js.erb"
      end

      it "approve order when the number cart bigger than inventory" do
        cookies.permanent.signed[symid.to_sym] = product.id.to_s + ","
        cookies.permanent[symquantity.to_sym] = 12.to_s + ","
        post :create, params: {order: {
          name: user.name,
          phone: user.phone,
          address: "48 Phan Chau Trinh",
          approve: 1
        }}, format: :js
        is_expected.to redirect_to cart_index_path
      end

      it "not allow to order when missing information order" do
        cookies.permanent.signed[symid.to_sym] = product.id.to_s + ","
        cookies.permanent[symquantity.to_sym] = 12.to_s + ","
        post :create, params: {order: {
          name: nil,
          phone: nil,
          address: nil,
          approve: 1
        }}, format: :js
        is_expected.to render_template "order/create.js.erb"
      end
    end
  end

  describe "#update" do
    context "Gues User" do
      it "not allow to update" do
        post :update, params: {
          id: order.id,
          status: 1
        }
        is_expected.to redirect_to root_path
      end
    end

    context "Gues User" do
      before {sign_in user}
      it "not allow to update" do
        post :update, params: {
          id: order.id,
          status: 1
        }
        is_expected.to redirect_to root_path
      end
    end

    context "Admin User" do
      before {sign_in admin}
      it "allow to update" do
        post :update, params: {
        id: order.id,
        status: 1
        }, format: :js
        new_order = Order.find order.id
        expect(new_order.status).to eql "processing"
      end
    end
  end
end
