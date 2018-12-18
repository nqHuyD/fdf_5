class SessionsController < ApplicationController
  def create
    @user = User.find_by email: params[:sessions][:email_login].downcase
    if @user && @user.authenticate(params[:sessions][:password_login])
      flash[:success] = t "layouts.notification.flash.success.login"
      authenticate_create @user
    else
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def authenticate_create user
    log_in user
    if params[:sessions][:remember] == Settings.validates.user.sessions.remember
      remember user
    else
      forget user
    end
    redirect_to root_path
  end
end
