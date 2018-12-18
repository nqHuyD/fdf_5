class OrderMailer < ApplicationMailer
  default from: "admin@gmail.com"

  def mail_to_admin user_id, order_id
    @user = User.find user_id.to_i
    @order = Order.find order_id.to_i
    mail to: "huynguyennbk@gmail.com", subject: I18n.t("mail.subject",
      name: @user.name)
  end

  def send_static_to_admin
    @month = Date.today.strftime("%B")

    # Total Revenue
    @revenue = Order.where(status: "success").sum(:totalPrice)

    # Order Success
    @order = Order.where(status: "success")

    # Total Product Selling
    @products = Product.joins(:product_orders).where("product_id IN (?) and
      order_id IN (?)",Product.all.ids, @order.ids).distinct

    # Top Product Selling
    hash_p = ProductOrder.where("order_id IN (?)",@order.ids)
      .group(:product_id).sum(:quanity)
    top_product_id = hash_p.key(hash_p.values.max)
    @top_product = Product.find top_product_id

    # Top Category Selling
    hash_c = ProductOrder.where("order_id IN (?)",@order.ids).joins(:categorys)
      .group(:category_id).sum(:quanity)
    top_category_id = hash_c.key(hash_c.values.max)
    @top_category = Category.find top_category_id

    mail to: "huynguyennbk@gmail.com",
      subject: I18n.t("mail.endmonth.subject", month: @month)
  end
end
