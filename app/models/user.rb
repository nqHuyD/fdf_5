class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  has_many :orders
  has_many :ranks

  scope :sort_by_newest, ->{order("created_at desc")}

  attr_accessor :remember_token

  mount_uploader :profile_img, AvatarUploader

  enum role: [:admin, :staff, :deliver, :customer]

  validate :profile_size

  def from_omniauth auth_hash
    user = find_or_create_by(uid: auth_hash["uid"],
      provider: auth_hash["provider"])
    user.name = auth_hash["info"]["name"]
    user.email = auth_hash["info"]["email"]
    user.profile_img = auth_hash["info"]["picture"]
    user.password = "123456"

    user.save!
    user
  end

  class << self
    def admin?
      return true if role == "admin"
      false
    end
  end

  private

  # Validates the size of an uploaded picture.
  def size_notify
    errortext = I18n.t("layouts.errors.userlogin.updatingform.avatarsize")
    errors.add(:profile_img, errortext)
  end

  def profile_size
    limitsize = Settings.validates.user.avatar.size.maximum.megabytes
    size_notify if profile_img.size > limitsize
  end
end
