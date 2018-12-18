class Category < ApplicationRecord
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

  paginates_per Settings.admin.category_per_page

  scope :sort_by_newest, ->{order("created_at desc")}

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
