require 'rails_helper'

RSpec.describe Category, type: :model do
   describe Category do

    context "Validation" do
      describe "Has Valid Category" do
        subject {FactoryGirl.create :category}
        it {is_expected.to be_valid}
      end

      describe "Not Valid without name" do
        subject {FactoryGirl.build :category}
        before {subject.name = nil}
        it {is_expected.to have(2).errors_on(:name)}
      end

      describe "Not Valid without status" do
        subject {FactoryGirl.build :category}
        before {subject.status = nil}
        it {is_expected.to have(1).errors_on(:status)}
      end

      describe "Not Valid without type_food" do
        subject {FactoryGirl.build :category}
        before {subject.type_food = nil}
        it {is_expected.to have(1).errors_on(:type_food)}
      end

      describe "Not Valid with duplicate name" do
        subject {FactoryGirl.build :category}
        before {@another_category = FactoryGirl.create :category}
        it {is_expected.to have(1).errors_on(:name)}
      end
    end

    context "Relation Model" do
       it {is_expected.to have_many(:product_categorys)}
    end

    context "Scope" do
      describe "applies scope order newest" do
        subject {Category.sort_by_newest.to_sql}
        it {is_expected.to eql Category.order("created_at desc").to_sql}
      end
    end
  end
end
