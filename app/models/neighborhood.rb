require './concerns/reservation_methods'

class Neighborhood < ActiveRecord::Base
	include ReservationMethods::InstanceMethods
	extend ReservationMethods::ClassMethods

  	belongs_to :city
  	has_many :listings

  	def neighborhood_openings(date1, date2)
  		open_listings(self.listings, date1, date2)
  	end
end
