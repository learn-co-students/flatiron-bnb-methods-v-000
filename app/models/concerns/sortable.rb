module Concerns
	module Concerns::Sortable

		def self.included(base)
    	base.extend(ClassMethods)
  	end
		
  	module ClassMethods

			def most_res
		  	y = self.all.collect { |x| x if x.reservation_count.is_a?(Integer) }
		  	y.compact.sort { |a,b| a.reservation_count <=> b.reservation_count }.last
		  end

		  def highest_ratio_res_to_listings
		 		y = self.all.collect { |x| x if x.ratio.is_a?(Float) }
		 		y.compact.sort { |a, b| a.ratio <=> b.ratio }.first
			end

		end


	  def reservation_count 
	  	x =	listings.collect { |listing| listing.reservations.size }
	  	x.inject(:+)
	  end

		def ratio
			if !listings.empty? && !reservation_count.nil? && reservation_count != 0
				listings.size/reservation_count.to_f
			end
		end
 	end
end 			