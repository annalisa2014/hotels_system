class Hotel < ActiveRecord::Base
  validates :name, presence: true
  validates :country_code, presence: true
  validates :average_price, presence: true

  has_many :users, through: :hotel_user

  def description

  end
end
