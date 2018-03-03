require "rails_helper"

describe "Hotel" do
  describe 'when visited, should increment views number' do
    before(:example) do
      @hotel = Hotel.new
    end

    it 'views are initially empty' do
      expect(@hotel.views_count).to eq(0)
    end

    context "after a hotel has been visited" do
      before(:example) do
        @hotel.manage_view_counter
      end

      it 'views are incremented' do
        expect(@hotel.views_count).to eq(1)
      end
    end
  end

  describe '#header_language_to_currency' do
    before(:example) do
      @hotel = Hotel.new
    end

    it 'If Header Accept-language is es, currency must be USD' do
      expect(@hotel.header_language_to_currency('es')).to eq('USD')
    end

    it 'if Header Accept-language is en, currency must be GBP' do
      expect(@hotel.header_language_to_currency('en')).to eq('GBP')
    end

    it 'If Header Accept-language is it, currency must be EUR' do
      expect(@hotel.header_language_to_currency('it')).to eq('EUR')
    end

    it 'If Header Accept-language is zh (chinese), currency must be defaulted to EUR' do
      expect(@hotel.header_language_to_currency('zh')).to eq('EUR')
    end
  end

  describe '#to_euro' do
    before(:example) do
      @hotel = Hotel.new
      bank = EuCentralBank.new
      bank.update_rates #if bank.last_updated.blank? || bank.last_updated < 1.day.ago
      Money.default_bank = bank
    end

    it 'USD are converted to EUR' do
      mymoney = Money.new(10000, 'USD').as_euro.to_i
      myeuro = @hotel.to_euro(100, "USD").to_i
      expect(mymoney == myeuro).to be_truthy
    end
  end
end