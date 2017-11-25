module SharedMethods 
	extend ActiveSupport::Concern
	module ClassMethods
		def highest_ratio_res_to_listings
  	 		self.all.max_by do |place| 
  	 			if place.listings.count == 0
  	 				0
  	 			else
  	 			 	place.listings.map{|l| l.reservations.count}.sum / place.listings.count
  	 			end
  	 		end
   		end


    	def most_res
  	 		self.all.max_by{|place| place.listings.map{|l| l.reservations.count}}
    	end
    end

    module InstanceMethods

    	["neighborhood", "city"].each do |place|
	  		define_method("#{place}_openings") do |arg1, arg2|
				self.listings.each do |listing|
  		  			listing.reservations.each do |reservation|
  			 			(reservation.checkin - arg2.to_date) * (arg1.to_date - reservation.checkout) < 0
  		 	 		end
  			 	end
  			end
  		end
    end
end