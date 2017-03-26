class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(starting, ending)
    start_date = Date.parse(starting)
    end_date = Date.parse(ending)

    available = []

    Listing.all.each do |listing|
     if listing.reservations.none? {|reservation| (start_date < reservation.checkout) && (end_date > reservation.checkin)}
        available << listing
      end
    end
  available
  end

  def self.most_res
    listing = highest_listings.flatten.max_by do |listing|
      listing.reservations_count
    end
    listing.neighborhood.city
  end

  def self.highest_listings
    City.all.collect do |city|
      city.listings.order("listings.reservations_count DESC").limit(1)
    end
  end

end
