App.notification_order = App.cable.subscriptions.create "NotificationOrderChannel",
  connected: ->

  disconnected: ->

  received: (data) ->
    $.ajax
      url: '/admin/realtime_notify',
      type: 'POST',
      data:
        name: data['name_id'],
        order: data['order_id']
    return
