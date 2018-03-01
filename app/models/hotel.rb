class Hotel < ActiveRecord::Base
  validates :name, presence: true
  validates :country_code, presence: true
  validates :average_price, presence: true

  has_many :managers
  has_many :users, through: :managers

  def description

  end
end
