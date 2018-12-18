class Order < ApplicationRecord
  before_create :set_status
  belongs_to :user
  has_many :product_orders

  scope :all_current_day, ->{where("DATE(created_at) = ?", Date.today)}
  scope :newest, ->{order("created_at desc")}

  enum status: [:pending, :processing, :success, :transfering, :cancel]

  validates :address, presence: true,
    length: {maximum: Settings.validates.order.address.length.maximum}
  validates :phone,
    length: {minimum: Settings.validates.user.phone.length.minimum}
  validates :name,
    length: {maximum: Settings.validates.user.name.length.maximum}

  private

  def set_status
    self.status = 0 if status.nil?
  end
end
