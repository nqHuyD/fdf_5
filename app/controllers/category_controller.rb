class CategoryController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_category, except: :create

  def create
    @category = Category.new name: category_params[:name],
      status: category_params[:status], type_food: category_params[:type_food]
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
    ActiveRecord::Base.transaction do
      begin
        # Delete ProductCategory Rows that having @category data
        ProductCategory.where(category_id: @category.id).each(&:destroy)

        # Delete Category Rows that having @category data
        @category.destroy
      rescue ActiveRecord::RecordInvalid
        flash[:warning] = t "layouts.notification.flash.danger.deletedata"
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
    return render :errorFind unless @category
  end
end
