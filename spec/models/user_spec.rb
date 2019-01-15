require 'rails_helper'

RSpec.describe User, type: :model do
  describe User do
    context "Validation" do
      describe "Has Valid User" do
        subject {FactoryGirl.create :user}
        it {is_expected.to be_valid}
      end

      describe "should not valid with email is wrong format" do
        subject {FactoryGirl.build :user}
        before {subject.email = "sad@s"}
        it {is_expected.to have(1).errors_on(:email)}
      end

      describe "should not valid without name" do
        subject {FactoryGirl.build :user}
        before {subject.name = nil}
        it {is_expected.to have(1).errors_on(:name)}
      end

      describe "should not valid without email" do
        subject {FactoryGirl.build :user}
        before {subject.email = nil}
        it {is_expected.to have(2).errors_on(:email)}
      end

      describe "should not valid without phone" do
        subject {FactoryGirl.build :user}
        before {subject.phone = nil}
        it {is_expected.to have(3).errors_on(:phone)}
      end

      describe "should not valid with too short phone" do
        subject {FactoryGirl.build :user}
        before {subject.phone = "032421"}
        it {is_expected.to have(1).errors_on(:phone)}
      end

      describe "should not valid with phone is not number" do
        subject {FactoryGirl.build :user}
        before {subject.phone = "abcxyzsdads"}
        it {is_expected.to have(1).errors_on(:phone)}
      end

      describe "Not Valid with duplicate phone" do
        subject {FactoryGirl.build :user}
        before {@another_user = FactoryGirl.create :user, phone: subject.phone}
        it {is_expected.to have(1).errors_on(:phone)}
      end

      describe "Not Valid with duplicate email" do
        subject {FactoryGirl.build :user}
        before {@another_user = FactoryGirl.create :user, email: subject.email}
        it {is_expected.to have(1).errors_on(:email)}
      end
    end

    context "Relation Model" do
       it {is_expected.to have_many(:orders)}
       it {is_expected.to have_many(:ranks)}
    end

    context "Scope" do
      describe "applies scope order newest" do
        subject {User.sort_by_newest.to_sql}
        it {is_expected.to eql User.order("created_at desc").to_sql}
      end
    end
  end
end
