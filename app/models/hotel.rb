class Hotel < ActiveRecord::Base
  validates :name, presence: true
  validates :country_code, presence: true
  validates :average_price, presence: true

  def description

  end
end
