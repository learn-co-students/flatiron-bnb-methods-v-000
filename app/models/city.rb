class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  include Reservable
  extend Reservable

 	def city_openings(startdate, enddate)
		city_openings = []
		listings.each do |listing|
			city_openings << listing if !(listing.reservations.any? {|res| 
			res.checkin.to_s <= enddate && res.checkout.to_s >= startdate})
		end
		city_openings
  end

end

