class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    start_date = Date.parse start_date
    end_date = Date.parse end_date
    @city_listings = []
    self.listings.each {|l| @city_listings << l}
    r = Reservation.where("checkin <= ? and checkout >= ?", end_date, start_date)
    @city_listings.keep_if {|listing| !listing.reservations.include?(r)}
  end

  def self.most_res
    City.all.max_by {|city| city.total_reservations}
  end

  def total_reservations
    @total = 0
    self.listings.each do |listing|
      @total += listing.reservations.count
    end
    @total
  end

  def self.highest_ratio_res_to_listings
    City.all.max_by {|city| city.total_reservations/city.listings.count}
  end

end
