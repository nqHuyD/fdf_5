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
    render partial: "user_data_row", locals: {users: users}
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

  #OrderData Part
  def render_order_row orders
    @orders = orders
    render partial: "order_data_row", locals: {orders: @orders}
  end

  def init_products_data items
    @products = Product.find_by id: items.product_id
  end

  def label_order_status status
    case status
    when "pending"
      render html: '<span class="badge badge-secondary">
       Pending</span>'.html_safe
    when "processing"
      render html: '<span class="badge badge-warning">
        Processing </span>'.html_safe
    when "success"
      render html: '<span class="badge badge-success">
        Success </span>'.html_safe
    when "transfering"
      render html: '<span class="badge badge-info">
        Transfering </span>'.html_safe
    when "cancel"
    render html: '<span class="badge badge-danger">
      Cancel </span>'.html_safe
    end
  end

  #CategoryData Part
  def render_category_row category
    @category = category
    render partial: "category_data_row"
  end

  def label_category_status status
    case status
    when "new_stuff"
      render html: '<span class="badge badge-warning">
       New Stuff</span>'.html_safe
    when "fresh"
      render html: '<span class="badge badge-primary">
       Fresh</span>'.html_safe
    when "trending"
      render html: '<span class="badge badge-danger">
       Trending</span>'.html_safe
    when "most_favorite"
      render html: '<span class="badge badge-success">
       Most Favorite</span>'.html_safe
    end
  end

  def sort_by_type type
    case type
    when "all"
      Category.all
    when "food"
      Category.where(type_food: "food")
    when "drink"
      Category.where(type_food: "drink")
    end
  end

  def sort_by_status status, category
    case status
    when "all"
      category
    when "new_stuff"
      category.where(status: "new_stuff")
    when "fresh"
      category.where(status: "fresh")
    when "trending"
      category.where(status: "trending")
    when "most_favorite"
      category.where(status: "most_favorite")
    end
  end
end
