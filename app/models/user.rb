class User < ActiveRecord::Base
  before_create :set_auth_token

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :language, presence: true

  has_many :managers
  has_many :hotels, through: :managers

  def initialize(attributes = {})
    super
    if attributes.any?
      self.email = attributes[:email]
      self.first_name = attributes[:first_name]
      self.last_name = attributes[:last_name]
      self.language = attributes[:language]
      self.salt = SecureRandom.base64(8)
      self.password = Digest::SHA2.hexdigest(self.salt + attributes[:password])
    end
  end

  def add_managed_hotel(hotel)
    self.hotels << hotel
    self.manager = true
  end

  def generate_token_if_loggedin(pwd)
    generate_auth_token if password_correct? pwd
  end

  def password_correct?(pwd)
    self.password == Digest::SHA2.hexdigest(self.salt + pwd)
  end

  def is_manager?
    self.manager || self.hotels.size > 0
  end

  def is_hotel_manager?(hotel)
    is_manager? && self.hotels.exists?(hotel)
  end

  private
  def set_auth_token
    return if self.token.present?
    self.token = generate_auth_token
  end

  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/,'')
  end
end
