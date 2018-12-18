# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

2.times do |n|
  name = "Sapageti"
  inventory = 10
  description = "This is so delicious"
  price = rand(2..50)
  Product.create!(name: name, inventory: inventory,
    description: description, price: price)
end

products = Product.all
3.times do
  picture = File.open(Rails.root + "public/uploads/foodtest.jpg")
  products.each {|product| product.food_images.create!(picture: picture)}
end
