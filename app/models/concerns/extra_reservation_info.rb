module ReservationHelpers
	

	module InstanceMethods
		def dates_overlap?(date1_start, date1_end, date2_start, date2_end)
			# puts "date1_start: #{date1_start}, date1_end: #{date1_end}, date2_start:#{date2_start}, date2_end:#{date2_end}"
			# puts "result #{(date1_start..date1_end).overlaps?(date2_start..date2_end)}"
			(date1_start..date1_end).overlaps?(date2_start..date2_end)
		end
		
		def open_listings(date1, date2)
			listings_open = []
			self.listings.each do |listing|
				if listing.reservations.empty?
					listings_open << listing
				elsif listing.listing_is_open?(date1, date2)
					listings_open << listing
				end
			end
			listings_open
		end

		def reservations_to_listings_ratio
			if self.listings.empty?
				ratio = 0 
			else
				ratio = self.reservations.count / self.listings.count
			end
		end

		def listing_is_open?(proposed_date1, proposed_date2)
			if self.reservations
				self.reservations.each do |reservation|
					if dates_overlap?(proposed_date1, proposed_date2, reservation.checkin, reservation.checkout)
						return false
					end
				end
				return true
			end
			return true
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

		def highest_ratio_res_to_listings
			place_with_highest_ratio = self.all.first
			highest_ratio = place_with_highest_ratio.reservations_to_listings_ratio
			self.all.each do |place|
				if place.reservations_to_listings_ratio > highest_ratio
					place_with_highest_ratio = place
					highest_ratio = place.reservations_to_listings_ratio
				end
			end
			place_with_highest_ratio
		end

	end


end