class NotificationOrderChannel < ApplicationCable::Channel
  def subscribed
    stream_from "order:#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
