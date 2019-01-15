require 'rails_helper'
require "cancan/matchers"

RSpec.describe CategoryController, type: :controller do
  let (:admin) {FactoryGirl.create :user, role: 0}
  let(:user) {FactoryGirl.create :user}
  let(:category) {FactoryGirl.create :category}

  describe "#create" do
    context "Guest User" do
      it "do not allow create" do
        post :create, params: {category: {
          name: "Fast_Food", status: 1, type_food: 1
         }}, format: :js
        is_expected.to redirect_to root_path
      end
    end

    context "Normal User" do
      before {sign_in user}
      it "do not allow create" do
        post :create, params: {category: {
          name: "Fast_Food", status: 1, type_food: 1
        }}, format: :js
        is_expected.to redirect_to root_path
      end
    end

    context "Admin User" do
      before {sign_in admin}
      it "allow to create" do
        post :create, params: {category: {
          name: "Fast_Food", status: 1, type_food: 1
        }}, format: :js
        expect(response.body).to match "/admin/category_data"
      end

      it "can not create when category is invalid" do
        post :create, params: {category: {
          name: nil, status: 1, type_food: 1
        }}, format: :js
        is_expected.to render_template "category/create"
      end
    end
  end

  describe "#destroy" do
    context "Guest User" do
      before {category}
      it "do not allow to destroy" do
        post :destroy, params: {id: category.id}
        is_expected.to redirect_to root_path
      end
    end

    context "Normal User" do
      before {sign_in user}
      it "do not allow to destroy" do
        post :destroy, params: {id: category.id}
        is_expected.to redirect_to root_path
      end
    end

    context "Admin User" do
      before {sign_in admin}
      it "allow to destroy" do
        category
        old_product = Category.count
        post :destroy, params: {id: category.id}, format: :js
        expect(Product.count).to eql old_product-1
      end

      it "process when category nil" do
        post :destroy, params: {id: 0}, format: :js
        is_expected.to render_template "user/errorFind"
      end

      it "can not destroy category when transaction fails" do
        allow_any_instance_of(Category).to receive(:really_destroy!)
          .and_raise(ActiveRecord::RecordInvalid)
        post :destroy, params: {id: category.id}, format: :js
        is_expected.to redirect_to "/admin/category_data?locale=en"
      end
    end
  end
end
