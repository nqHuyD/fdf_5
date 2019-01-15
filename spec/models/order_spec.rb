require 'rails_helper'

RSpec.describe Order, type: :model do
  describe Order do
    context "Validation" do
      it "should not valid without name" do
        FactoryGirl.build(:order, name: nil).should_not be_valid
      end

      it "should not valid without phone" do
        FactoryGirl.build(:order, phone: nil).should_not be_valid
      end

      it "should not valid without address" do
        FactoryGirl.build(:order, address: nil).should_not be_valid
      end

       it "should not valid with phone is not a number" do
        FactoryGirl.build(:order, phone: "abc").should_not be_valid
      end
    end

    context "Relation Model" do
       it {is_expected.to have_many(:product_orders)}
       it {is_expected.to belong_to(:user)}
    end

    context "Scope" do
      it "applies scope order newest" do
        scope = Order.sort_by_newest
        scope.to_sql.should == Order.order("created_at desc").to_sql
      end

      it "applies scope current_date" do
        scope = Order.all_current_day
        condition = Order.where("DATE(created_at) = ?", Date.today)
        scope.to_sql.should == condition.to_sql
      end
    end
  end
end
