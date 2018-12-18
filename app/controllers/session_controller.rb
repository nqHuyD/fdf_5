class SessionController < ApplicationController
  def create
    @user = User.find_by email: params[:session][:email_login].downcase
    if @user && @user.authenticate(params[:session][:password_login])
      authenticate_create @user
    else
      fail_action
    end
  end

  def authenticate_create user
    log_in user
    if params[:session][:remember] == Settings.validates.user.session.remember
      remember user
    else
      forget
    end
    redirect_to root_path
  end

  private

  def fail_action; end
end
