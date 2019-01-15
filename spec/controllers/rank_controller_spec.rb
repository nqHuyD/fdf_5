require 'rails_helper'
require "cancan/matchers"

RSpec.describe RankController, type: :controller do
  let(:product) {FactoryGirl.create :product, inventory: 10}
  let (:admin) {FactoryGirl.create :user, role: 0}
  let(:user) {FactoryGirl.create :user}
  let(:rank) {FactoryGirl.create :rank,
    user_id: user.id, product_id: product.id}

  describe "#create" do
    context "Guest User" do
      it "not allow to create" do
        post :create, params: {product_id: product.id, star: 5}, format: :js
        is_expected.to redirect_to root_path
      end
    end

    context "Normal User" do
      before {sign_in user}
      it "allow to create" do
        post :create, params: {product_id: product.id}, format: :js
        is_expected.to render_template "rank/create"
      end
    end
  end

  describe "#update" do
    context "Normal User" do
      before {sign_in user}
      it "allow to update when rank is exist" do
        rank
        post :create, params: {product_id: product.id, star: 4}, format: :js
        new_rank = Rank.find rank.id
        expect(new_rank.ranking).to eql 4
      end

      it "allow to reset star" do
        post :reset_star, format: :js
        is_expected.to render_template "rank/create.js.erb"
      end
    end
  end
end
