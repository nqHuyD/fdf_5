class OrderMailer < ApplicationMailer
  default from: "admin@gmail.com"

  def mail_to_admin user_id, order_id
    @user = User.find user_id.to_i
    @order = Order.find order_id.to_i
    mail to: "huynguyennbk@gmail.com", subject: I18n.t("mail.subject", name: @user.name)
  end
end
