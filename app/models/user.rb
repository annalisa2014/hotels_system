class User < ActiveRecord::Base
  before_create :set_auth_token

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :language, presence: true

  def crypt_password(pwd)
    self.salt = SecureRandom.base64(8)
    self.password = Digest::SHA2.hexdigest(self.salt + pwd)
  end

  def generate_token_if_loggedin(pwd)
    generate_auth_token if password_correct? pwd
  end

  def password_correct?(pwd)
    self.password == Digest::SHA2.hexdigest(self.salt + pwd)
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
