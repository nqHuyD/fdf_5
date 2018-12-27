class Product < ApplicationRecord
  has_many :food_images

  enum category: [:fastfood, :chocolate, :salads, :sandwiches, :koreanfood,
    :japanfood, :desserts, :soda, :fruitdrink, :milktea, :coffee, :tea]

  validates :name, presence: true,
    length: {maximum: Settings.validates.food.name.length.maximum}
  validates :description,
    length: {maximum: Settings.validates.food.description.length.maximum}
end
