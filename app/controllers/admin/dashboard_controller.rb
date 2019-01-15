class Admin::DashboardController < Admin::AdminApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_sort_category, only: :sort_category
  before_action :init_update_product, only: :update_product
  before_action :load_notify_data, only: [:notify_data, :realtime_notify]

  def overview; end

  def notify_data; end

  def user_data
    @user_data = User.all.sort_by_newest.page params[:page]
  end

  def category_data
    @category_data = Category.all.sort_by_newest.page params[:page]
  end

  def product_data
    @category_data = Category.all
    @product_data = Product.all.sort_by_newest.page params[:page]
    session[:category_product] = []
  end

  def order_data
    @order_data = Order.all.sort_by_newest.page params[:page]
  end

  def sort_category
    respond_to do |format|
      if @category.count.zero?
        flash[:danger] = t "layouts.notification.flash.danger.sortcategory"
        format.js{render js: "window.location.replace('/admin/category_data');"}
      else
        format.js
      end
    end
  end

  # Select Type Food When Render Data
  def type_product_choice
    # Init Params
    params[:category] = nil if params[:category].blank?
    params[:type_food] = "all" if params[:type_food].blank?
    @type_food = Category.where(type_food: params[:type_food])
    @type_food = Category.all if params[:type_food] == "all"

    # Processing when admin click Category Filter for Product
    filter_product_processing
  end

  def filter_product_processing
    @filter_product = @type_food.where(name: params[:category])
    @filter_product = @type_food if params[:category].nil?

    @product_data = Product.joins(:product_categorys)
    category_ids = @filter_product.ids
    @product_data = @product_data.where("category_id IN (?)", category_ids)
    respond_to do |format|
      format.js
    end
  end

  # Select Type Food or Drink
  def category_product_option
    @category_data = Category.all
    @type = params[:type]
    @category_data_product = @category_data.where(type_food: @type)
    @category_data_product = @category_data if @type == "all"
    respond_to do |format|
      format.js
    end
  end

  # Append Category Product
  def category_product_append
    if session[:category_product].include?(params[:category].to_i)
      respond_to do |format|
        format.js{render js: "alert('Category are ready on Box');"}
      end
    else
      session[:category_product].push params[:category].to_i
      respond_to do |format|
        format.js
      end
    end
  end

  ## Update Controller
  # Update Activites
  def update_activites
    @activities = PublicActivity::Activity.find params[:active_id]
    @activities.update_column :read, !@activities.read
    respond_to do |format|
      format.js
    end
  end

  # Update users Active
  def active_update_users
    authorize! :update, User

    @users = User.find_by id: params[:id].to_i
    params[:active] = detect_active params[:active]
    if params[:active].present? && @users.active.blank?
      @users.restore
    elsif params[:active].blank? && @users.active.present?
      @users.destroy
    end
    respond_to do |format|
      format.js
    end
  end

  # Update Category
  def update_category
    authorize! :update, Category

    @category_data = Category.all.sort_by_newest.page(params[:page])
    @category_data = @category_data.per_page Settings.admin.category_per_page
    @category = Category.find_by id: params[:id]
    if @category.update_attributes category_params
      respond_to do |format|
        format.js{render "sucess_update_category.js.erb"}
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  # Update Category Active
  def active_update_category
    authorize! :update, Category

    @category = Category.find_by id: params[:id].to_i
    params[:active] = detect_active params[:active]
    if params[:active].present? && @category.active.blank?
      @category.restore
    elsif params[:active].blank? && @category.active.present?
      @category.destroy
    end
    respond_to do |format|
      format.js
    end
  end

  # Update Product
  def update_product
    authorize! :update, Product

    if @update_status
      respond_to do |format|
        format.js{render "sucess_update_product.js.erb"}
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  # Update Products Active
  def active_update_products
    authorize! :update, Product

    @products = Product.find_by id: params[:id].to_i
    params[:active] = detect_active params[:active]
    if params[:active].present? && @products.active.blank?
      @products.restore
    elsif params[:active].blank? && @products.active.present?
      @products.destroy
    end
    respond_to do |format|
      format.js
    end
  end

  ## Destory Controller
  # Destroy Category Product
  def category_product_destroy
    authorize! :destroy, Category

    session[:category_product].delete(params[:category].to_i)
    respond_to do |format|
      format.js{render "category_product_append.js.erb"}
    end
  end

  # Destroy Product
  def product_destroy
    authorize! :destroy, Product

    @product = Product.find_by id: params[:id]
    ActiveRecord::Base.transaction do
      begin
        product_destroy_processing
      rescue StandardError
        flash[:warning] = "Can not Delete this data"
        respond_to do |format|
          product_location = "window.location.replace('/admin/product_data');"
          format.js{render js: product_location}
        end
      end
      flash[:success] = "Destroy Product Success"
      respond_to do |format|
        format.js{render js: "window.location.replace('/admin/product_data');"}
      end
    end
  end


  ## RealTime Notify
  def realtime_notify
    @user = User.find params[:name]
    @order = Order.find params[:order]
    @total_product = @order.product_orders.count
    respond_to do |format|
      format.js
    end
  end

  private

  def product_params
    params.require(:product)
  end

  def category_params
    params.require(:category).permit :name, :status, :type_food
  end

  def init_product
    @product_data = Product.all.sort_by_newest.page params[:page]
    @product = Product.find_by id: params[:id]
  end

  def load_notify_data
    activity = PublicActivity::Activity.all.order("created_at desc")
    @activities = activity.page params[:page]
  end

  def load_sort_category
    type_food = params[:type_food]
    status = params[:status]
    @category = sort_by_type type_food
    @category = sort_by_status status, @category
  end

  def detect_active param
    return true if param == "true"
    false
  end

  def init_update_product
    init_product
    @update_status = @product.update_attributes name: product_params[:name],
      inventory: product_params[:inventory], price: product_params[:price],
      description: product_params[:description]
  end

  def product_destroy_processing
    ProductCategory.where(product_id: @product.id).each(&:destroy)

    # Delete Food Images Rows that having @product data
    FoodImage.where(product_id: @product.id).each(&:destroy)

    # Delete Rank Rows that having @product data
    Rank.where(product_id: @product.id).each(&:destroy)

    # Delete Product Orders that having @product data
    ProductOrder.where(product_id: @product.id).each(&:destroy)

    @product.really_destroy!
  end
end
