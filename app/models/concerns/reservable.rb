module Reservable
	extend ActiveSupport::Concern
	
	def openings(startDate, endDate)
  	range = ((Date.parse startDate)..(Date.parse endDate))
  	listings.select{|listing| listing.open_during?(range)}
  end
	
	
	def total_reservations
    if listings.empty?
      0
    else
      listings.max do |l1, l2|
        l1.reservations.length <=> l2.reservations.length
      end.reservations.length
    end
  end
	
	
	module ClassMethods
		
		def highest_ratio_res_to_listings
	    self.all.max_by do |place|
	      place.total_reservations.to_f / (place.listings.length + 1).to_f
	    end
	  end
	  
	  def most_res
	    self.all.max_by do |place|
	      place.total_reservations
	    end
	  end
		
		
	end
	
end