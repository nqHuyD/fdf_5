class CategoryController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_category, only: :destroy

  def create
    authorize! :create, Category
    @category = Category.new name: category_params[:name],
      status: category_params[:status].to_i,
      type_food: category_params[:type_food].to_i
    respond_to do |format|
      if @category.save
        flash[:success] = t "layouts.notification.flash.success.category"
        format.js{render js: "window.location.replace('/admin/category_data');"}
      else
        format.js
      end
    end
  end

  def destroy
    authorize! :destory, Category
    ActiveRecord::Base.transaction do
      begin
        # Delete ProductCategory Rows that having @category data
        ProductCategory.where(category_id: @category.id).each(&:destroy)

        # Delete Category Rows that having @category data
        @category.really_destroy!
      rescue ActiveRecord::RecordInvalid
        flash[:warning] = "Can not Delete this data"
        redirect_to admin_category_data_url
      end
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def category_params
    params.require(:category).permit :name, :status, :type_food
  end

  def load_category
    @category = Category.find_by id: params[:id].to_i
    return render :"user/errorFind" unless @category
  end
end
