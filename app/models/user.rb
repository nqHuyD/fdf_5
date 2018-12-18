class User < ApplicationRecord
  attr_accessor :remember_token

  before_save :downcase_email

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

  private

  def downcase_email
    email.downcase!
  end
end
