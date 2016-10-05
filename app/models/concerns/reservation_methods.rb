module ReservationMethods
	

	module InstanceMethods
		
		def open_listings(listings, date1, date2)
			listings_open = []
			listings.each do |listing|
				if listing.reservations.empty?
					listings_open << listing
				else
					listing.reservations.each do |reservation|
						reservations_with_no_conflict = 0
					if !dates_overlap?(reservation.checkin, reservation.checkout, date1, date2)
						reservations_with_no_conflict += 1
					end
				end
				if reservations_with_no_conflict == listing.reservations.count
					listings_open << listing
				end
			end
			listings_open
		end

		def reservations_to_listings_ratio(place)	
			place.reservations.count / place.listings.count
		end

		def reservations_
			all_reservations = []
			self.listings.each do |listing|
				all_reservations << listing.reservations
			end
			all_reservations.flatten.compact!
		end

	end


	module ClassMethods


		def most_res
			place_with_max_reservations = self.all.first
			max_reservations = place_with_max_reservations.reservations.count

			self.all.each do |place|
				if place.reservations.count > max_reservations
					place_with_max_reservations = place
					max_reservations = place.reservations.count
				end
			end
			place_with_max_reservations
		end

		def self.highest_ratio_res_to_listings
			place_with_highest_ratio = self.all.first
			highest_ratio = reservations_to_listings_ratio(place_with_highest_ratio)
			self.all.each do |place|
				if reservations_to_listings_ratio(place) > highest_ratio
					place_with_highest_ratio = place
					highest_ratio = reservations_to_listings_ratio(place)
				end
			end
			place_with_highest_ratio
		end

	end

end
end