module Admin::DashboardHelperData
  # User Data
  def render_user_row users
    @users = users
    render partial: "user_data_row", locals: {users: users}
  end

  def label_role_user roles
    case roles
    when nil
      render html: '<span class="badge badge-dark">None</span>'.html_safe
    when "admin"
      render html: '<span class="badge badge-warning">Admin</span>'.html_safe
    when "staff"
      render html: '<span class="badge badge-primary">Staff</span>'.html_safe
    when "deliver"
      render html: '<span class="badge badge-light">Deliver</span>'.html_safe
    when "customer"
      render html: '<span class="badge badge-success">Customer</span>'.html_safe
    end
  end

  # OrderData Part
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
      render html: '<span class="badge badge-secondary">Pending
        </span>'.html_safe
    when "processing"
      render html: '<span class="badge badge-warning">
      Processing </span>'.html_safe
    when "success"
      render html: '<span class="badge badge-success">Success </span>'.html_safe
    when "transfering"
      render html: '<span class="badge badge-info">Transfering</span>'.html_safe
    when "cancel"
      render html: '<span class="badge badge-danger">Cancel </span>'.html_safe
    end
  end

  # CategoryData Part
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
      render html: '<span class="badge badge-primary">Fresh</span>'.html_safe
    when "trending"
      render html: '<span class="badge badge-danger">Trending</span>'.html_safe
    when "most_favorite"
      render html: '<span class="badge badge-success">
        Most Favorite</span>'.html_safe
    end
  end

  # ProductData Part
  def render_product_row products
    @products = products
    render partial: "product_data_row"
  end

  def label_status_product status
    case status
    when nil
      render html: '<span class="badge badge-secondary">
       None-Status</span>'.html_safe
    when "new_stuff"
      render html: '<span class="badge badge-warning">
        New Stuff</span>'.html_safe
    when "best_sell"
      render html: '<span class="badge badge-success">Staff</span>'.html_safe
    when "stunning"
      render html: '<span class="badge badge-info">Deliver </span>'.html_safe
    when "high_rate"
      render html: '<span class="badge badge-danger">Customer</span>'.html_safe
    end
  end
end
