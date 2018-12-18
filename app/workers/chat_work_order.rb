class ChatWorkOrder
  @queue = :chatwork

  def self.perform user_name, order_no
    receiver = ChatWork::Me.get["name"]
    account_id = ChatWork::Me.get["account_id"]
    room_id = ChatWork::Me.get["room_id"]
    message_body = "[To:#{account_id}] #{receiver}\n #{user_name} has recently order number #{order_no}"
    ChatWork::Message.create room_id: room_id, body: message_body
  end
end
