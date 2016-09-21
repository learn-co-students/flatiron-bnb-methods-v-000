class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date_string, end_date_string)
    start_date = Date.parse(start_date_string)
    end_date = Date.parse(end_date_string)
    Listing.all.find_all do |listing|
      listing.reservations.all? do |reservation|
        reservation.checkin >= end_date || reservation.checkout <= start_date
      end
    end
  end

  def numberOfReservations
    self.listings.inject(0) do |sum, listing|
      sum + listing.reservations.size
    end
  end

  def self.highest_ratio_res_to_listings
    City.all.max_by do |city|
      city.numberOfReservations.to_f / city.listings.size
    end
  end

  def self.most_res
    City.all.max_by do |city|
      city.numberOfReservations
    end
  end
end

