module Admin::DashboardHelper
  # Overview Part
  def total_user
    User.count
  end

  def total_order
    Order.count
  end

  def current_order
    Order.all_current_day.count
  end

  def total_earnings
    total = 0
    Order.all.each do |order|
      total += order.totalPrice
    end
    total
  end

  def label_active active
    case active
    when true
      render html: '<span class="badge badge-success">
       Active</span>'.html_safe
    when false
      render html: '<span class="badge badge-danger">
        Not Active </span>'.html_safe
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

  def render_category_box_data category
    @category_data = Category.find_by id: category.to_i
    render partial: "category_product_box_data"
  end

  include Admin::DashboardHelperData
end
