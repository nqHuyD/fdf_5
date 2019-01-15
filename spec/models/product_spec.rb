require 'rails_helper'

RSpec.describe Product, type: :model do
  describe Product do
    context "Validation" do
      it "has a valid Product" do
        FactoryGirl.create(:product).should be_valid
      end

      it "should not valid without name" do
        FactoryGirl.build(:product, name: nil).should_not be_valid
      end

      it "should not valid without description" do
        FactoryGirl.build(:product, description: nil).should_not be_valid
      end

      it "should not valid without inventory" do
        FactoryGirl.build(:product, inventory: nil).should_not be_valid
      end

      it "should not valid without price" do
        FactoryGirl.build(:product, price: nil).should_not be_valid
      end

      it "should not valid with inventory less than 1" do
        FactoryGirl.build(:product, inventory: -1).should_not be_valid
      end

      it "should not valid with price less than 1" do
        FactoryGirl.build(:product, price: -1).should_not be_valid
      end
    end

    context "Relation Model" do
       it {is_expected.to have_many(:food_images)}
       it {is_expected.to have_many(:product_orders)}
       it {is_expected.to have_many(:ranks)}
       it {is_expected.to have_many(:product_categorys)}
    end

    context "Scope" do
      it "applies scope order newest" do
        scope = Product.sort_by_newest
        scope.to_sql.should == Product.order("created_at desc").to_sql
      end
    end
  end
end
