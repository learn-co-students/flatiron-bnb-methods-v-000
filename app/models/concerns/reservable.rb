module Reservable
	extend ActiveSupport::Concern
	# more about it http://api.rubyonrails.org/classes/ActiveSupport/Concern.html

	def ratio_reservations_to_listings
		listings_count = self.listings.count
		reservations_count = self.listings.map{ |listing| listing.reservations.count}.reduce(:+)
		reservations_count ? reservations_count / listings_count : 0
	end

	def neighborhood_openings(start_date, end_date)
	  	listings.select{ |listing| listing.available?(start_date, end_date) }
	end	

	# can be used as a concern by neighborhoods, cities (to replace 'x') 
	class_methods do
		def highest_ratio_res_to_listings
			all.max_by{  |x| x.ratio_reservations_to_listings }
		end

		def most_res
			#neighborood has many listings has many reservations
			all.max { |a, b| a.reservations.count <=> b.reservations.count }
		end
	end
	
end