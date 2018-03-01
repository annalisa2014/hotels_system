class HotelViewsCountJob < ActiveJob::Base
  queue_as :default

  def perform(args)
    hotel = Hotel.find(args.first)
    hotel.increment!(:views_count)
  end
end
