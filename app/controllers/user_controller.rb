class UserController < ApplicationController
  before_action :load_user, only: :update

  def create
    @user = User.new user_params
    if @user.save
      # Success Notification
      log_in @user
      render "static_pages/home"
    else
      # Fails Notification
    end
  end

  def update
    if @user.update_attributes user_params
      # Success Notification
      redirect_to root_path
    else
      # Fails Notification
    end
  end

  private

  def user_params
    params.require(:user).permit :name,
      :email, :password, :password_confirmation, :phone, :profile_img
  end

  def load_user
    @user = User.find_by id: params[:id]
    # Fails Notification
  end
end
