class ChatWorkOrder
  @queue = :chatwork

  def self.perform user_name, order_no
    receiver = ChatWork::Me.get["name"]
    account_id = ChatWork::Me.get["account_id"]
    room_id = ChatWork::Me.get["room_id"]
    @order = Order.find order_no
    number_products = @order.product_orders.count
    message_body = "[To:#{account_id}] #{receiver}\n #{user_name} has recently ordered #{number_products} product"
    ChatWork::Message.create room_id: room_id, body: message_body
  end
end
