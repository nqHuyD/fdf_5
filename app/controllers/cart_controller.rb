class CartController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :user_validate, only: :create
  before_action :initcart, only: :create

  def index; end

  def create
    if current_cart.present?
      present_in_cart_process current_cart
    else
      addcookie @quantity
    end
    respond_to do |format|
      format.js
    end
  end

  def update
    params[:newVal] = 1 if params[:newVal].to_i == 0
    updatecookie params[:id], params[:newVal]
    respond_to do |format|
      format.js
    end
  end

  def destroy
    destroycookie params[:id]
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
    @quantity = params[:quantity]
    @symid = 'cartno_'+ @user.id.to_s
    @symquantity = 'cartquantity_' + @user.id.to_s
  end

  def present_in_cart_process cart
    if cart.include? @product.id.to_s
        quantityindex = cart.index @product.id.to_s
        if @quantity.nil?
          quantity =  current_quanity[quantityindex].to_i + 1
        else
          quantity =  current_quanity[quantityindex].to_i + @quantity.to_i
        end
        addcookie quantity.to_s, quantityindex
      else
        addcookie @quantity
      end
  end
end
