class Category < ApplicationRecord
  has_many :product_categorys

  scope :newest, ->{order("created_at desc")}

  enum status: [:new_stuff, :fresh, :trending, :most_favorite]
  enum type_food: [:food, :drink]

  length_name_max = Settings.validates.category.name.length.maximum
  length_name_min = Settings.validates.category.name.length.minimum
  validates :name, presence: true,
    length: {maximum: length_name_max, minimum: length_name_min},
    uniqueness: {case_sensitive: false}
  validates :status, presence: true
  validates :type_food, presence: true
end
