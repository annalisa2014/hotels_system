class HotelViewsCountJob < ActiveJob::Base
  queue_as :default

  def perform(args)
    hotel = Hotel.find(args)
    hotel.increment!(:views_count)
  end
end
