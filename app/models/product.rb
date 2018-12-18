class Product < ApplicationRecord
  has_many :food_images
  has_many :product_orders
  has_many :ranks
  has_many :product_categorys

  # Soft Deleted With Gem Paranoia
  acts_as_paranoid column: :active, sentinel_value: true,
    without_default_scope: true

  def paranoia_restore_attributes
    {
      deleted_at: nil,
      active: true
    }
  end

  def paranoia_destroy_attributes
    {
      deleted_at: current_time_from_proper_timezone,
      active: false
    }
  end

  paginates_per Settings.admin.product_per_page

  scope :sort_by_newest, ->{order("created_at desc")}

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
