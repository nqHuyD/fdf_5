require 'rails_helper'

RSpec.describe Order, type: :model do
  describe Order do
    context "Validation" do
      describe "Not Valid without name" do
        subject {FactoryGirl.build :order}
        before {subject.name = nil}
        it {is_expected.to have(1).errors_on(:name)}
      end

      describe "Not Valid without phone" do
        subject {FactoryGirl.build :order}
        before {subject.phone = nil}
        it {is_expected.to have(3).errors_on(:phone)}
      end

      describe "Not Valid without address" do
        subject {FactoryGirl.build :order}
        before {subject.address = nil}
        it {is_expected.to have(1).errors_on(:address)}
      end

      describe "Not Valid with phone is not number" do
        subject {FactoryGirl.build :order}
        before {subject.phone = "abcxyzsdads"}
        it {is_expected.to have(1).errors_on(:phone)}
      end
    end

    context "Relation Model" do
       it {is_expected.to have_many(:product_orders)}
       it {is_expected.to belong_to(:user)}
    end

    context "Scope" do
      describe "applies scope order newest" do
        subject {Order.sort_by_newest.to_sql}
        it {is_expected.to eql Order.order("created_at desc").to_sql}
      end

       describe "applies scope current_date" do
        subject {Order.all_current_day.to_sql}
        condition = Order.where("DATE(created_at) = ?", Date.today)
        it {is_expected.to eql  condition.to_sql}
      end
    end
  end
end
