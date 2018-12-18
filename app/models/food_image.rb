class FoodImage < ApplicationRecord
  belongs_to :product

  mount_uploader :picture, FoodUploader

  validate :foodimage_size

  def size_notify
    errortext = I18n.t "layouts.errors.prodcuts.foodimages.imagesize"
    errors.add(:picture, errortext)
  end

  def foodimage_size
    limitsize = Settings.validates.food.imagesize.maximum.megabytes
    size_notify if picture.size > limitsize
  end
end
