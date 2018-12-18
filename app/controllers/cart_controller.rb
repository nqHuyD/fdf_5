class CartController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :user_validate, only: :create
  before_action :initcart, only: :create

  def create
    if @categoryarray.present?
      if @categoryarray.include? @product.id.to_s
        quantityindex = @categoryarray.index @product.id.to_s
        quantity =  @quantityarray[quantityindex].to_i + 1
        addcookie quantity.to_s, quantityindex
      else
        addcookie
      end
    else
      addcookie
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def user_validate
    if logged_in?
      @user = current_user
    else
      redirect_to product_index_path
    end
  end

  def initcart
    @product = Product.find_by id: params[:product_id]
    @symid = 'cartno_'+ @user.id.to_s
    @symquantity = 'cartquantity_' + @user.id.to_s
    @totalprice = 0
  end
end
