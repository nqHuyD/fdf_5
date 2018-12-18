class OrderController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :user_params, only: :create
  before_action :load_orders, only: :update

  def index; end

  def create
    @order = current_user.orders.new name: user_params[:name],
      phone: user_params[:phone], address: user_params[:address]

    @current_cart = current_cart
    @current_quantity = current_quanity
    @errorlist = []

    # Check inventory of current product
    if @current_cart.nil?
      respond_to do |format|
        format.js {render "empty.js.erb"}
      end
    else
      test_inventory
      errorlist_check
    end
  end

  def update
    @orders.update_attribute :status, params[:status].to_i
    respond_to do |format|
      format.js
    end
  end

  private

  def user_params
    params.require(:order)
  end

  def load_orders
    @orders = Order.find_by id: params[:id]
  end

  # Saving Order Features
  def saving_order approve=nil
    if @order.save
      product_order approve
    else
      respond_to do |format|
        format.js {render "create.js.erb"}
      end
    end
  end

  # Product Order Processing
  def product_order approve
    totalprice = 0 #Calculator Order Total Price
    for i in 0..@current_cart.length-1
      product = find_product @current_cart[i]
      if @current_quantity[i].to_i > product.inventory
        @current_quantity[i] = product.inventory if approve.present?
      end
      totalprice +=  @current_quantity[i].to_i * product.price
      newinventory = product.inventory - @current_quantity[i].to_i
      product.update_attribute :inventory, newinventory

      @order.product_orders.create(product_id: @current_cart[i],
        unitprice: product.price, quanity: @current_cart[i].to_i)
    end
    @order.update_attribute :totalPrice, totalprice
    destroy_all_cart
    flash[:success] = "You Order is Processing"
    redirect_to cart_index_path
  end

  # Test inventory is empty or not
  def test_inventory
    for item in 0..@current_cart.length-1
      product = Product.find_by id: @current_cart[item].to_i
      if product.inventory < @current_quantity[item].to_i
        @errorlist.push @current_cart[item].to_i
      end
    end
  end

  # Check User Approve to pay the rest inventory
  def approve_check
    if user_params[:approve].present?
      saving_order user_params[:approve]
    end
  end

  # Check Whether Inventory is enough
  def errorlist_check
    if @errorlist.blank?
      saving_order
    else
      approve_check
      if user_params[:approve].nil?
        respond_to do |format|
          format.js {render "errorlist.js.erb"}
        end
      end
    end
  end
end
