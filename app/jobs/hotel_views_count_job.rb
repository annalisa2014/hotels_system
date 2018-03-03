class HotelViewsCountJob < ActiveJob::Base
  queue_as :default

  def perform(args)
    hotel = Hotel.find(args)
    hotel.manage_view_counter
  end
end
