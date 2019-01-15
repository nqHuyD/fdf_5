require "rails_helper"
require "cancan/matchers"

RSpec.describe UserController, type: :controller do
  let (:admin) {FactoryGirl.create :user, role: 0}
  let(:user) {FactoryGirl.create :user}
  let(:user_test) {FactoryGirl.create :user, phone: "0935732124"}

  describe "#update_role" do

    context "Guest User" do
      subject {
        post :update_role,
        params: {id: user.id, role: 3},
        format: :js
      }
      it {is_expected.to redirect_to root_path}
    end

    context "Normal User" do
      before {sign_in user}
      subject {
        post :update_role,
        params: {id: user_test.id, role: 3}
      }
      it {is_expected.to redirect_to root_path}
    end

    context "Admin User" do
      before {sign_in admin}
      it "allow to change role" do
        id = user_test.id
        post :update_role, params: {id: id, role: 3},format: :js
        expect(User.find(id).role).to eql "deliver"
      end
    end
  end

  describe "#destroy" do

    context "Guest User" do
      subject {delete :destroy, params: {id: user_test.id}}
      it {is_expected.to redirect_to root_path}
    end

    context "Normal User" do
      before {sign_in user}
      subject {delete :destroy, params: {id: user_test.id}}
      it {is_expected.to redirect_to root_path}
    end

    context "Admin User" do
      before {sign_in admin}
      it "allow destroy user" do
        user_test
        old_count = User.count
        delete :destroy, params: {id: user_test.id}, format: :js
        expect(User.count).to eql old_count - 1
      end

      it "can not destroy when user nil" do
        allow_any_instance_of(User).to receive(:really_destroy!).and_return(:false)
        delete :destroy, params: {id: user_test.id}, format: :js
        expect(response.header['Content-Type']) == :js
      end
    end
  end
end
