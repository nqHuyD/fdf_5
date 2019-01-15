require 'rails_helper'

RSpec.describe Product, type: :model do
  describe Product do
    context "Validation" do
      describe "Has Valid Product" do
        subject {FactoryGirl.create :product}
        it {is_expected.to be_valid}
      end

      describe "Not Valid without name" do
        subject {FactoryGirl.build :product}
        before {subject.name = nil}
        it {is_expected.to have(1).errors_on(:name)}
      end

      describe "Not Valid without description" do
        subject {FactoryGirl.build :product}
        before {subject.description = nil}
        it {is_expected.to have(1).errors_on(:description)}
      end

      describe "Not Valid without inventory" do
        subject {FactoryGirl.build :product}
        before {subject.inventory = nil}
        it {is_expected.to have(2).errors_on(:inventory)}
      end

      describe "Not Valid without price" do
        subject {FactoryGirl.build :product}
        before {subject.price = nil}
        it {is_expected.to have(2).errors_on(:price)}
      end

      describe "should not valid with inventory less than 1" do
        subject {FactoryGirl.build :product}
        before {subject.inventory = -1}
        it {is_expected.to have(1).errors_on(:inventory)}
      end

      describe "should not valid with price less than 1 " do
        subject {FactoryGirl.build :product}
        before {subject.price = -1}
        it {is_expected.to have(1).errors_on(:price)}
      end
    end

    context "Relation Model" do
       it {is_expected.to have_many(:food_images)}
       it {is_expected.to have_many(:product_orders)}
       it {is_expected.to have_many(:ranks)}
       it {is_expected.to have_many(:product_categorys)}
    end

    context "Scope" do
      describe "applies scope order newest" do
        subject {Product.sort_by_newest.to_sql}
        it {is_expected.to eql Product.order("created_at desc").to_sql}
      end
    end
  end
end
