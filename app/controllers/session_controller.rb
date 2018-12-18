class SessionController < ApplicationController
  def create
    @user = User.find_by email: params[:session][:email_login].downcase
    if @user&.authenticate(params[:session][:password_login])
      authenticate_create @user
    else

      # Fail Notification
    end

    respond_to do |format|
      format.js
    end
  end

  def authenticate_create user
    log_in user
    if params[:session][:remember] == Settings.validates.user.session.remember
      remember user
    else
      forget user
    end
    redirect_to root_path
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
