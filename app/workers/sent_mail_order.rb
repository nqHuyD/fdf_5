class SentMailOrder
  @queue = :mailer

  def self.perform user_id, order_id
    OrderMailer.mail_to_admin(user_id, order_id).deliver
  end
end
