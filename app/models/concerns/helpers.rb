class Helpers
  def self.openings(listings, query_range)
    open_listings = []

    listings.each do |listing|
     if listing.reservations.none? do |reservation|
           range = reservation.checkin..reservation.checkout
           range.overlaps?(query_range)
        end
        open_listings << listing
      end
    end
    open_listings
  end
end
