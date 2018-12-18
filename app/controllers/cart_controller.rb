class CartController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :user_validate, only: :create
  before_action :initcart, only: :create

  def index; end

  def create
    if current_cart.present?
      if current_cart.include? @product.id.to_s
        quantityindex = current_cart.index @product.id.to_s
        quantity =  current_quanity[quantityindex].to_i + 1
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
    @symid = 'cartno_'+ @user.id.to_s
    @symquantity = 'cartquantity_' + @user.id.to_s
  end
end
