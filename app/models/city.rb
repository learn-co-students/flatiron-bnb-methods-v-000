class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def self.most_res
    @reservations_hash = {}
    all_reservations = []
    
    # find the number of reservations in each city, and place it in a hash
    City.all.each do |city|
      Reservation.all.each do |reservation|
        all_reservations << reservation
      end
      @reservations_hash[city.id] = all_reservations.keep_if{ |reservation| reservation.listing.neighborhood.city.id == city.id }.size
    end
    #sort the hash by value to identify the city with the most reservations
    City.find(@reservations_hash.sort_by{|key, value| value }.last[0])
  end


  def self.highest_ratio_res_to_listings
    cities = City.all
    @listings_hash = {}
    @reservations_to_listings_ratio = {}
    
    #total total reservations for each city
    self.most_res
    #total listings for each city
    cities.each do |city|
      @listings_hash[city.id] = city.listings.count
    end
    #creating a ratio based on the two previous hashes
    cities.each do |city|
      @reservations_to_listings_ratio[city.id] = @reservations_hash[city.id].fdiv(@listings_hash[city.id])
    end
    #sorting the newly created hash
    City.find(@reservations_to_listings_ratio.sort_by{ |key, value| value}.last[0])
  end


  def city_openings(checkin_string, checkout_string)
    all_listings = []

    Listing.all.each do |listing|
      all_listings << listing
    end

    #listings within this city that are not available during that date range
    listings_not_available(checkin_string, checkout_string)
    #all listings that are available during that date range
    all_listings.keep_if{ |listing| !@all_listings_in_date_range.include?(listing)}

  end

  def listings_not_available(checkin_string, checkout_string)
    checkin_date = Date.parse(checkin_string)
    checkout_date = Date.parse(checkout_string)
    all_reservations = []
    @all_listings_in_date_range = []
    
    # 1) find all reservations
    Reservation.all.each do |reservation|
      all_reservations << reservation
    end
    # 2) keep only the reservations from that city
    all_reservations.keep_if{ |reservation| reservation.listing.neighborhood.city_id == self.id}
    # 3) keep only the reservations from that city from a date range
    all_reservations.keep_if{ |reservation| !(reservation.checkin > checkout_date) && !(reservation.checkout < checkin_date) }
    # 4) keeping the listings that are booked in a date range
    all_reservations.each do |reservation|
      @all_listings_in_date_range << reservation.listing
    end
  end

end


