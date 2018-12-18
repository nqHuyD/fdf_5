class CategoryController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_category, except: :create

  def create
    @category = Category.new name: category_params[:name],
      status: category_params[:status], type_food: category_params[:type_food]
   if @category.save
    flash[:success] = t "layouts.notification.flash.success.category"
    redirect_to admin_category_data_path
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "layouts.notification.flash.success.categoryUpdate"
      redirect_to admin_category_data_path
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.js
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