class UserController < ApplicationController
  def create
    @user = User.new user_params
    if @user.save
      # Success Notification
      log_in @user
      render "static_pages/home"
    else
      fail_action
    end
  end

  private

  def user_params
    params.require(:user).permit :name,
      :email, :password, :password_confirmation, :phone
  end

  def fail_action; end
end
