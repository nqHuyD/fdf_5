class Admin::DashboardController < Admin::AdminApplicationController
  before_action :init_data, except: :overview

  def overview; end

  def user_data; end

  def category_data; end

  def product_data; end

  def order_data; end

  private

  def init_data
    @user_data = User.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.user_per_page

    @order_data = Order.all.sort_by_newest.page(params[:page])
    .per_page Settings.admin.order_per_page
  end
end
