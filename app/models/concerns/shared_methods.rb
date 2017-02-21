module SharedMethods
	






	module ClassMethods
  		def highest_ratio_res_to_listings
		    resources = self.all
		    highest_resource = self.first
		    highest_ratio = 0
		    resources.each do |resource|
		      number_of_reservations = 0
		      number_of_listings = resource.listings.count
		      resource.listings.each do |listing|
		        number_of_reservations += listing.reservations.count
		      end
		      ratio = "#{number_of_reservations}.00".to_f / number_of_listings
		      if ratio > highest_ratio
		        highest_ratio = ratio
		        highest_resource = resource
		      end
		    end
		    highest_resource
  		end

		def most_res
		    resources = self.all
		    highest_resource = self.first
		    highest_reservation_count = 0
		    resources.each do |resource|
		      reservation_count = 0
		      resource.listings.each do |listing|
		        reservation_count += listing.reservations.count
		      end
		      if reservation_count > highest_reservation_count
		        highest_reservation_count = reservation_count
		        highest_resource = resource
		      end
		    end
		    highest_resource
		end
	end
end