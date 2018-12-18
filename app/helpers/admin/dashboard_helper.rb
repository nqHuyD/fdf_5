module Admin::DashboardHelper

  # Overview Part
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

  #UserData Part
  def render_user_row users
    @users = users
    render partial: "user_data_row", locals:{users: users}
  end

  def label_role_user roles
    case roles
    when nil
      render html: '<span class="badge badge-dark">
       None</span>'.html_safe
    when "admin"
      render html: '<span class="badge badge-warning">
        Admin </span>'.html_safe
    when "staff"
      render html: '<span class="badge badge-primary">
        Staff </span>'.html_safe
    when "deliver"
      render html: '<span class="badge badge-light">
        Deliver </span>'.html_safe
    when "customer"
      render html: '<span class="badge badge-success">
        Customer </span>'.html_safe
    end
  end
end
