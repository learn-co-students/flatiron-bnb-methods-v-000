class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  # returns all the Listings for this Neighborhood that are available for the entire supplied date range.
  def neighborhood_openings(start_date, end_date)
    Listing.find_openings(listings, start_date, end_date)
  end

  # returns the Neighborhood that has the highest reservations per listing average.
  def self.highest_ratio_res_to_listings
    Listing.highest_reservation_to_listing_ratio(self.all)
  end

  # returns the Neighborhood that has the most reservations.
  def self.most_res
    Listing.most_reservations(self.all)
  end

end
