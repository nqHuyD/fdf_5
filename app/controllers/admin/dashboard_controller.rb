class Admin::DashboardController < Admin::AdminApplicationController
  skip_before_action :verify_authenticity_token
  before_action :init_data, except: :overview
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

  private

  def init_data
    @user_data = User.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.user_per_page

    @order_data = Order.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.order_per_page

    @category_data = Category.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.category_per_page
  end

  def load_sort_category
    type_food = params[:type_food]
    status = params[:status]
    @category = sort_by_type type_food
    @category = sort_by_status status, @category
  end
end
