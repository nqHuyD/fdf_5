class UserController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_user, only: :update
  before_action :admin_load_user, only: [:update_role, :destroy]

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "layouts.notification.flash.success.signup"
      log_in @user
      redirect_to root_path
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "layouts.notification.flash.success.update"
      redirect_to root_path
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def update_role
    @users.update_attribute :role, params[:role].to_i - 1
    respond_to do |format|
      format.js
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      begin
        # Delete Rank Rows that having @user data
        Rank.where(product_id: @users.id).each(&:destroy)

        @users.destroy
      rescue StandardError
        flash[:warning] = "Data has the order so can not Delete"
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

  def user_params
    params.require(:user).permit :name,
      :email, :password, :password_confirmation, :phone, :profile_img
  end

  def load_user
    @user = User.find_by id: params[:id]
    return render "errorFind" unless @user
  end

  def admin_load_user
    @users = User.find_by id: params[:id].to_i
    return render "errorFind" unless @users
  end
end
