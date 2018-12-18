class Category < ApplicationRecord
  has_many :product_categorys

  scope :sort_by_newest, ->{order("created_at desc")}

  enum status: [:new_stuff, :fresh, :trending, :most_favorite]
  enum type_food: [:food, :drink]

  validates :name, presence: true,
    length: {maximum: Settings.validates.category.name.length.maximum,
    minimum: Settings.validates.category.name.length.minimum },
    uniqueness: {case_sensitive: false}
  validates :status, presence: true
  validates :type_food, presence: true
end
