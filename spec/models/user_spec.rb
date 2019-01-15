require 'rails_helper'

RSpec.describe User, type: :model do
  describe User do
    context "Validation" do
      it "has a valid User" do
        FactoryGirl.create(:user).should be_valid
      end

      it "should not valid with email is wrong format" do
        FactoryGirl.build(:user, email: "hfds@s").should_not be_valid
      end

      it "should not valid without username" do
        FactoryGirl.build(:user, name: nil).should_not be_valid
      end

      it "should not valid without email" do
        FactoryGirl.build(:user, email: nil).should_not be_valid
      end

      it "should not valid without phone" do
        FactoryGirl.build(:user, phone: nil).should_not be_valid
      end

      it "should not valid with too_short phone" do
        FactoryGirl.build(:user, phone: "032421").should_not be_valid
      end

      it "should not valid with phone is not number" do
        FactoryGirl.build(:user, phone: "aabxcs").should_not be_valid
      end

      it "should not valid with phone is duplicate" do
        phone = FactoryGirl.create(:user).phone
        FactoryGirl.build(:user, phone: phone).should_not be_valid
      end

      it "should not valid with email is duplicate" do
        email = FactoryGirl.create(:user).email
        FactoryGirl.build(:user, email: email).should_not be_valid
      end
    end

    context "Relation Model" do
       it {is_expected.to have_many(:orders)}
       it {is_expected.to have_many(:ranks)}
    end

    context "Scope" do
      it "applies scope order newest" do
        scope = User.sort_by_newest
        scope.to_sql.should == User.order("created_at desc").to_sql
      end
    end
  end
end
