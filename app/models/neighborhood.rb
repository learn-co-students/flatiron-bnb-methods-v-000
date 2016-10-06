require 'concerns/extra_reservation_info'

class Neighborhood < ActiveRecord::Base
	include ReservationHelpers::InstanceMethods
	extend ReservationHelpers::ClassMethods

  	belongs_to :city
  	has_many :listings

  	def neighborhood_openings(date1, date2)
  		open_listings(date1, date2)
  	end

  	def reservations
		if self.class != Listing
			all_reservations = []
			self.listings.each do |listing|
				all_reservations << listing.reservations
			end
			all_reservations.flatten
		end
	end

end
