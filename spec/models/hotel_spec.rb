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
end