require 'concerns/extra_reservation_info'

class Neighborhood < ActiveRecord::Base
	include ReservationHelpers::InstanceMethods
	extend ReservationHelpers::ClassMethods

  	belongs_to :city
  	has_many :listings

  	def neighborhood_openings(date1, date2)
  		open_listings(self.listings, date1, date2)
  	end

end
