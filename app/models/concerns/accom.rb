
module Accom

	def openings(checkin, checkout)
		self.listings.select do |listing|
        listing.reservations.all? do |res|
          (checkin.to_datetime >= res.checkout) || (checkout.to_datetime <= res.checkin)
        end
      end
    end

	def most_reservations	
		hood = []
		listed = Reservation.all.map {|lists| lists.listing_id}
		listed.each do |list|
			Listing.all.select do |areas| 
				if list == areas.id 
					hood << areas.neighborhood_id
				end
			end		
		end
		counting = Hash.new(0)
		hood.each {|v| counting[v] += 1}
		max_res = counting.select {|x,i| i == counting.values.max}
	end	
end	

