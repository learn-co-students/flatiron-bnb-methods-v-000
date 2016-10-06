module ReservationHelpers
	

	module InstanceMethods
		def dates_overlap?(start1, end1, start2, end2)
			(start1..end1).overlaps?(start2..end2)
		end
		
		def open_listings(date1, date2)
			listings_open = []
			self.listings.each do |listing|
				if listing.reservations.empty?
					listings_open << listing
				elsif listing.listing_open?(date1, date2)
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

		def listing_open?(date1, date2)
			#puts "in listing open"
			
			if !self.reservations || self.reservations.empty?
				true
			else
				reservations_with_no_conflict = 0
				self.reservations.each do |reservation|
			 		reservations_with_no_conflict = 0
			  		if !dates_overlap?(reservation.checkin, reservation.checkout, date1, date2)
			    		reservations_with_no_conflict += 1
			  		end
				end
				if reservations_with_no_conflict == self.reservations.count
					true
				end
			end
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