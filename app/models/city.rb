class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  # Returns all of the available apartments in a city, given the date range
  def city_openings(start_date, end_date)
    date_range = (Date.parse(start_date)..Date.parse(end_date))
    listings.collect do |listing|
      available = true
      listing.booked_dates.each do |date|
        if date_range === date
          available = false
        end
      end
      listing if available
    end
  end

  ## returns a cities ratio of reservations to listings. Returns 0 if there are no listings.

  def ratio_res_to_listings
    self.reservations.count.to_f / self.listings.count
  end

  def self.highest_ratio_res_to_listings
    self.all.sort {|x, y| x.ratio_res_to_listings <=> y.ratio_res_to_listings}.last
  end

  # Returns city with most reservations
  def self.most_res
    most_reservations = self.first
    self.all.each do |city|
      if city.reservations.count > most_reservations.reservations.count
        most_reservations = city
      end
    end
    most_reservations
  end

end
