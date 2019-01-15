require 'rails_helper'

RSpec.describe Category, type: :model do
   describe Category do
    context "Validation" do
      it "has a valid Category" do
        FactoryGirl.create(:category).should be_valid
      end

      it "should not valid without name" do
        FactoryGirl.build(:category, name: nil).should_not be_valid
      end

      it "should not valid without status" do
        FactoryGirl.build(:category, status: nil).should_not be_valid
      end

      it "should not valid without type food" do
        FactoryGirl.build(:category, type_food: nil).should_not be_valid
      end

      it "should not valid without duplicate name" do
        name = FactoryGirl.create(:category).name
        FactoryGirl.build(:category, name: name).should_not be_valid
      end
    end

    context "Relation Model" do
       it {is_expected.to have_many(:product_categorys)}
    end

    context "Scope" do
      it "applies scope order newest" do
        scope = Category.sort_by_newest
        scope.to_sql.should == Category.order("created_at desc").to_sql
      end
    end
  end
end
