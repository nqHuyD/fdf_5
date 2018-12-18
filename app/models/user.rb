class User < ApplicationRecord
  has_many :orders
  has_many :ranks

  scope :newest, ->{order("created_at desc")}
  before_save :downcase_email

  attr_accessor :remember_token

  mount_uploader :profile_img, AvatarUploader

  enum role: [:admin, :staff, :deliver, :customer]

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: true,
    length: {maximum: Settings.validates.user.name.length.maximum}
  validates :email, presence: true,
    length: {maximum: Settings.validates.user.email.length.maximum},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :phone, presence: true,
    length: {minimum: Settings.validates.user.phone.length.minimum},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.validates.user.password.length.minimum},
    allow_nil: true

  validate :profile_size

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  class << self
    def digest string
      min_cost = ActiveModel::SecurePassword.min_cost
      cost = min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

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

  private

  def downcase_email
    email.downcase!
  end

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
