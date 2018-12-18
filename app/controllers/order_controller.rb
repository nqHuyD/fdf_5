class OrderController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :user_params, only: :create
  before_action :load_order, only: :update

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
        format.js{render "empty.js.erb"}
      end
    else
      test_invetory
      errorlist_check
    end
  end

  def update
    respond_to do |format|
      if @orders.update_attribute :status, params[:status].to_i
        format.js
      else
        flash[:danger] = t "layouts.notification.flash.danger.update"
        redirect_to admin_order_data_path
      end
    end
  end

  def test_invetory
    @current_cart.each.with_index do |current_cart, index|
      product_test = Product.find_by id: current_cart.to_i
      if product_test.inventory < @current_quantity[index].to_i
        @errorlist.push current_cart[item].to_i
      end
    end
  end

  private

  def user_params
    params.require(:order)
  end

  def load_order
    @orders = Order.find_by id: params[:id]
  end

  # Saving Order Features
  def saving_order approve = nil
    if @order.save
      product_order approve
    else
      respond_to do |format|
        format.js{render "create.js.erb"}
      end
    end
  end

  # Product Order Following Approve
  def product_order approve
    @totalprice = 0 # Calculator Order Total Price
    product_order_processing approve
    @order.update_attribute :totalPrice, @totalprice
    destroy_all_cart
    flash[:success] = "You Order is Processing"
    redirect_to cart_index_path
  end

  # Product Order Processing
  def product_order_processing approve
    @current_cart.each.with_index do |current_cart, index|
      @product = find_product current_cart
      if @current_quantity[index].to_i > @product.inventory
        @current_quantity[index] = @product.inventory if approve.present?
      end
      update_product_inventory index
      @order.product_orders.create(product_id: current_cart,
        unitprice: @product.price, quanity: @current_quantity[index].to_i)
    end
  end

  # Update Product Inventory and Total Price Order
  def update_product_inventory index
    @totalprice += @current_quantity[index].to_i * @product.price
    newinventory = @product.inventory - @current_quantity[index].to_i
    @product.update_attribute :inventory, newinventory
  end

  # Check User Approve to pay the rest inventory
  def approve_check
    saving_order user_params[:approve] if user_params[:approve].present?
  end

  # Check Whether Inventory is enough
  def errorlist_check
    if @errorlist.blank?
      saving_order
    else
      approve_check
      if user_params[:approve].nil?
        respond_to do |format|
          format.js{render "errorlist.js.erb"}
        end
      end
    end
  end
end
