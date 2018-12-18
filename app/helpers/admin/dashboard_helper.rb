module Admin::DashboardHelper
  def total_user
    return User.count
  end

  def total_order
    return Order.count
  end

  def current_order
    return Order.all_current_day.count
  end

  def total_earnings
    total = 0
    Order.all.each do |order|
      total += order.totalPrice
    end
    total
  end
end
