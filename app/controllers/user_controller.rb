class UserController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :admin_load_user, only: [:update_role, :destroy]

  def update_role
    authorize! :update_role, User
    @users.update_attribute :role, params[:role].to_i-1
    respond_to do |format|
      format.js
    end
  end

  def destroy
    authorize! :destory, User

    ActiveRecord::Base.transaction do
      begin
        # Delete Rank Rows that having @user data
        Rank.where(user_id: @users.id).each(&:destroy)

        @user_order= Order.where(user_id: @users.id)

        # Delete Product Orders
        ProductOrder.where("order_id in (?)", @user_order.ids).each(&:destroy)

        # Delete Order Rows that having @user data
        @user_order.where(user_id: @users.id).each(&:destroy)

        @users.really_destroy!
      rescue StandardError
        flash[:warning] = "Data can not Delete"
        respond_to do |format|
          format.js{render js: "window.location.replace('/admin/user_data');"}
        end
      end
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def admin_load_user
    @users = User.find_by id: params[:id].to_i
    return render "errorFind" unless @users
  end
end
