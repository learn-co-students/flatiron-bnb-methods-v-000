module Reservable
   extend ActiveSupport::Concern

  def openings(start_date, end_date)
    listings.merge(Listing.available(start_date, end_date))
  end

  def ratio_reservations_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    else
      0
    end
  end

end
