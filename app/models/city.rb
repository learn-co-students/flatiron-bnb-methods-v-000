class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  # returns all the Listings for this City that are available for the entire supplied date range.
  def city_openings(start_date, end_date)
    Listing.find_openings(listings, Date.parse(start_date), Date.parse(end_date))
  end

  # returns the City that has the highest reservations per listing average.
  def self.highest_ratio_res_to_listings
    Listing.highest_reservation_to_listing_ratio(self.all)
  end

  # returns the City that has the most reservations.
  def self.most_res
    Listing.most_reservations(self.all)
  end
end
