require 'eu_central_bank'

class Hotel < ActiveRecord::Base
  validates :name, presence: true
  validates :country_code, presence: true
  validates :average_price, presence: true

  has_many :managers
  has_many :users, through: :managers

  def to_euro(amount, currency)
    init_central_bank_data
    new_currency = Money.new(amount, currency).exchange_to('EUR')
    if new_currency
      new_currency.fractional
    else
      amount
    end
  end

  def to_currency(currency)
    init_central_bank_data
    new_currency = Money.new(self.average_price, 'EUR').exchange_to(currency)
    if new_currency
      new_currency.fractional
    else
      amount
    end
  end

  def manage_view_counter
    self.increment!(:views_count)
  end

  def header_language_to_currency(header_lang)
    case header_lang
      when 'es'
        'USD'
      when 'en'
        'GBP'
      else
        'EUR'
    end
  end

  private
  def init_central_bank_data
    bank = EuCentralBank.new
    bank.update_rates #if bank.last_updated.blank? || bank.last_updated < 1.day.ago
    Money.default_bank = bank
  end
end
