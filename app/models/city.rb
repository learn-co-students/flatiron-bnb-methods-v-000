class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  
  extend Statistics::ClassMethods

  def city_openings(date1, date2)
    open_listings = self.listings.select do |listing|
      !listing.reservations.any?{|reservation| (reservation.checkin..reservation.checkout).cover?(Date.parse(date1)..Date.parse(date2))}
    end
  end

  #
  # def self.highest_ratio_res_to_listings
  #   all_reservations_by_listing_id = Reservation.group(:listing_id).count
  #
  #   #checks the details of listings for the reservations
  #   city_count={}
  #   all_reservations_by_listing_id.each {|key, value|
  #     the_city = City.find(Neighborhood.find(Listing.find(key).neighborhood_id).city_id)
  #     city_count.has_key?(the_city) ?  city_count[the_city]=city_count[the_city]+(value/the_city.listings.count.to_f) : city_count[the_city]=(value/the_city.listings.count.to_f)
  #   }
  #   max_listings_city = city_count.select {|k,v| v == city_count.values.max } # gets the max valued hash-key pair
  #   max_listings_city.keys[0] # since the city is stored as key return the key for the max value
  # end
  #
  # def self.most_res
  #   list = Reservation.group(:listing_id).count # gets the count of the reservations by counting how many reservations belong to each listing_id) and returns a hash
  #   max_res = list.select {|k,v| v == list.values.max }
  #   listing = Listing.find(max_res.keys[0])
  #   #binding.pry
  #   City.find(Neighborhood.find(listing.neighborhood_id).city_id)
  # end

end
