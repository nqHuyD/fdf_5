class Admin::DashboardController < Admin::AdminApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_sort_category, only: :sort_category

  def overview; end

  def user_data
    @user_data = User.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.user_per_page
  end

  def category_data
    @category_data = Category.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.category_per_page
  end

  def product_data
    @category_data = Category.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.category_per_page
    @product_data = Product.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.product_per_page
    session[:category_product] = []
  end

  def order_data
    @order_data = Order.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.order_per_page
  end

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

  #Update Category
  def update_category
    @category_data = Category.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.category_per_page
    @category = Category.find_by id: params[:id]
    if @category.update_attributes category_params
      respond_to do |format|
        format.js {render "sucess_update_category.js.erb"}
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  #Update Product
  def update_product
    @product_data = Product.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.product_per_page
    @product = Product.find_by id: params[:id]
    update_status = @product.update_attributes name: product_params[:name],
      inventory: product_params[:inventory], price: product_params[:price],
      description: product_params[:description]

    if update_status
      respond_to do |format|
        format.js {render "sucess_update_product.js.erb"}
      end
    else
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

     ActiveRecord::Base.transaction do
      begin

        # Delete ProductCategory Rows that having @product data
        ProductCategory.where(product_id: @product.id).each do |category|
          category.destroy
        end

        # Delete Food Images Rows that having @product data
        FoodImage.where(product_id: @product.id).each do |image|
          image.destroy
        end

        # Delete Rank Rows that having @product data
        Rank.where(product_id: @product.id).each do |rank|
          rank.destroy
        end

        # Delet Product Orders that having @product data
        ProductOrder.where(product_id: @product.id).each do |product_order|
          product_order.destroy
        end

        @product.destroy
      rescue
        flash[:warning] = "Can not Delete this data"
        return redirect_to admin_product_data_path
      end
      flash[:success] = "Destroy Product Success"
      redirect_to admin_product_data_path
    end
  end

  private
  def product_params
    params.require(:product)
  end

  def category_params
    params.require(:category).permit :name, :status, :type_food
  end

  def load_sort_category
    type_food = params[:type_food]
    status = params[:status]
    @category = sort_by_type type_food
    @category = sort_by_status status, @category
  end
end
