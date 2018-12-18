class Admin::AdminApplicationController < ActionController::Base
  layout "admin_standard"

  protect_from_forgery with: :exception
  before_action :set_locale

  include Admin::DashboardHelper

  def application; end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
