class SessionsController < ApplicationController
  def create
    if params[:sessions].present?
      # Login Normal
      log_in_normal
    else
      # Login Facebook
      log_in_facebook
    end
  end

  def log_in_normal
    @user = User.find_by email: params[:sessions][:email_login].downcase
    @authenticate = @user.authenticate(params[:sessions][:password_login])
    @active = @user.active.present?
    if @user && @authenticate && @active
      flash[:success] = t "layouts.notification.flash.success.login"
      authenticate_create @user
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def log_in_facebook
    user = User.from_omniauth(request.env["omniauth.auth"])
    sessions[:user_id] = user.id
    if user
      flash[:success] = "Welcome, #{user.email}"
    else
      flash[:warning] = "There was an error while authenticate"
    end
    redirect_to root_path
  end

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

  def failure
    render text: "Sorry, but you didn't allow access to our map"
  end
end
