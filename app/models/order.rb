class Order < ApplicationRecord
  belongs_to :user
  has_many :product_orders

  enum status: [:pending, :processing, :success, :transfering]

  validates :address, presence: true,
    length: {maximum: Settings.validates.order.address.length.maximum}
  validates :phone,
    length: {minimum: Settings.validates.user.phone.length.minimum}
  validates :name,
    length: {maximum: Settings.validates.user.name.length.maximum}

end
