# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

30.times do |n|
  name = "Sapageti"
  inventory = 10
  description = "This is so delicious"
  price = 5
  category = rand(0..11)
  if category < 7
    food = true
  else
    food = false
  end
  Product.create!(name: name, inventory: inventory, food: food,
    description: description, price: price, category: category)
end

products = Product.order(:created_at).take(20)
10.times do
  picture = File.open(Rails.root + "public/uploads/foodtest.jpg")
  products.each {|product| product.food_images.create!(picture: picture)}
end
