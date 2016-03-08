class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings


  extend Statistics::ClassMethods

  def neighborhood_openings(date1, date2)
    open_listings = self.listings.select do |listing|
      !listing.reservations.any?{|reservation| (reservation.checkin..reservation.checkout).cover?(Date.parse(date1)..Date.parse(date2))}
    end
  end

  # def self.highest_ratio_res_to_listings
  #   all_reservations_by_listing_id = Reservation.group(:listing_id).count
  #
  #   #checks the details of listings for the reservations
  #   neighborhood_count={}
  #   all_reservations_by_listing_id.each {|key, value|
  #     the_neighborhood = Neighborhood.find(Listing.find(key).neighborhood_id)
  #     neighborhood_count.has_key?(the_neighborhood) ?  neighborhood_count[the_neighborhood]=neighborhood_count[the_neighborhood]+(value/the_neighborhood.listings.count.to_f) : neighborhood_count[the_neighborhood]=(value/the_neighborhood.listings.count.to_f)
  #   }
  #   max_listings_neighborhood = neighborhood_count.select {|k,v| v == neighborhood_count.values.max } # gets the max valued hash-key pair
  #   max_listings_neighborhood.keys[0] # since the city is stored as key return the key for the max value
  # end
  #
  # def self.most_res
  #   list = Reservation.group(:listing_id).count
  #   max_res = list.select {|k,v| v == list.values.max }
  #   listing = Listing.find(max_res.keys[0])
  #   #binding.pry
  #   Neighborhood.find(listing.neighborhood_id)
  # end
end
