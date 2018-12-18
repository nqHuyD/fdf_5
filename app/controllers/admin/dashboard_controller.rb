class Admin::DashboardController < Admin::AdminApplicationController
  skip_before_action :verify_authenticity_token
  before_action :init_data, except: [:overview, :category_product_append,
    :category_product_option, :category_product_destroy]
  before_action :load_sort_category, only: :sort_category

  def overview; end

  def user_data; end

  def category_data; end

  def product_data; end

  def order_data; end

  def sort_category
    if @category.count == 0
      flash[:danger] = t "layouts.notification.flash.danger.sortcategory"
      redirect_to admin_category_data_path
    else
      respond_to do |format|
        format.js
      end
    end
  end

  # Select Type Food or Drink
  def category_product_option
    @category_data = Category.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.category_per_page
    @type = params[:type]
    if @type != "all"
      @category_data_product = @category_data.where(type_food: @type)
    else
      @category_data_product = @category_data
    end
    respond_to do |format|
      format.js
    end
  end

  # Append Category Product
  def category_product_append
    if session[:category_product].include?(params[:category].to_i)
      respond_to do |format|
        format.js {render :js => "alert('Category are ready on Box');"}
      end
    else
      session[:category_product].push params[:category].to_i
      respond_to do |format|
        format.js
      end
    end
  end

  # Destroy Category Product
  def category_product_destroy
    session[:category_product].delete(params[:category].to_i)
    respond_to do |format|
      format.js {render "category_product_append.js.erb"}
    end
  end

  #Destroy Product
  def product_destroy
    @product = Product.find_by id: params[:id]
    @product.destroy
    flash[:success] = "Destroy Product Success"
    redirect_to admin_product_data_path
  end

  private

  def init_data
    @user_data = User.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.user_per_page

    @order_data = Order.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.order_per_page

    @category_data = Category.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.category_per_page

    @product_data = Product.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.product_per_page

    session[:category_product] = []
  end

  def load_sort_category
    type_food = params[:type_food]
    status = params[:status]
    @category = sort_by_type type_food
    @category = sort_by_status status, @category
  end
end
