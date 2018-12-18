class Product < ApplicationRecord
  has_many :food_images
  has_many :product_orders
  has_many :ranks
  has_many :product_categorys

  scope :newest, ->{order("created_at desc")}

  scope :recent, ->{order "created_at DESC"}
  enum category: [:fastfood, :chocolate, :salads, :sandwiches, :koreanfood,
    :japanfood, :desserts, :soda, :fruitdrink, :milktea, :coffee, :tea]
  enum status: [:new_stuff, :best_sell, :stunning, :high_rate]

  validates :name, presence: true,
    length: {maximum: Settings.validates.food.name.length.maximum}
  validates :description, presence: true,
    length: {maximum: Settings.validates.food.description.length.maximum}
  validates :inventory, presence: true,
    numericality: {greater_than_or_equal_to: 1}
  validates :price, presence: true,
    numericality: {greater_than_or_equal_to: 1}
end
