desc "send static to admin"
task send_static_to_admin: :environment do
  # ... set options if any
  OrderMailer.send_static_to_admin.deliver!
end
