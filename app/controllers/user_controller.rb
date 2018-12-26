class UserController < ApplicationController
  before_action :load_user, only: :update

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "layouts.notification.flash.success.signup"
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

  private

  def user_params
    params.require(:user).permit :name,
      :email, :password, :password_confirmation, :phone
  end

  def load_user
    @user = User.find_by id: params[:id]
    return render "errorFind" unless @user
  end
end
