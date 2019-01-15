module Admin::DashboardHelper
  def activities_count
    PublicActivity::Activity.where(read: false).count
  end

  def render_notify active
    @active_id = active.id
    @action = active.key.split(".")[1].capitalize
    @order_id = active.owner_id if active.owner_id.present?
    @user = User.find_by id: active.trackable_id

    @user_name = @user.present? ? @user.name.capitalize : "NoName"
    @active_day = distance_of_time_in_words(active.created_at-DateTime.current)
    @read = active.read

    render partial: "notify_data_row"
  end

  def label_image_activity action
    case action
    when "Update"
      image_tag "update.png", class: "active_icon"
    when "Destroy"
      image_tag "destroy.png", class: "active_icon"
    when "Create"
      image_tag "create.png", class: "active_icon"
    when "Order"
      image_tag "order.png", class: "active_icon"
    end
  end

  def render_profile_img user
    image_tag @user.profile_img.url, class: "avatar_icon" if @user.present?
  end

  # Overview Part
  def total_user
    User.where(active: true).count
  end

  def total_order
    Order.where(status: 2).count
  end

  def current_order
    Order.where(status: 2).all_current_day.count
  end

  def total_earnings
    total = 0
    Order.where(status: 2).all.each do |order|
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
