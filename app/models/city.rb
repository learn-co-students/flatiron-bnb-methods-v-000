class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings
  
  # Returns all of the available apartments in a city, given the date range
  def city_openings(start_date, end_date)
    open_listings = listings.collect {|l| l if l.reservations.count == 0}
    reservations.each do |r|
      booked_dates = r.checkin..r.checkout
      unless booked_dates === Date.parse(start_date) || booked_dates === Date.parse(end_date)
        open_listings << r.listing
      end
    end
    open_listings.uniq
  end

  ## returns a cities ratio of reservations to listings. Returns 0 if there are no listings.

  def ratio_res_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    else
      0
    end
  end

  # Returns city with highest ratio of reservations to listings
  def self.highest_ratio_res_to_listings
    highest = self.first
    self.all.each do |city|
      if city.ratio_res_to_listings > highest.ratio_res_to_listings
        highest = city
      end
    end
    highest
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

