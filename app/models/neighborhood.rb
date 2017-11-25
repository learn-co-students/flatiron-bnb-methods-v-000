class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
  	@listings = Listing.all
  	@open_listings = []
  	@closed_listings = []

  	#find listings with reservations
  	@reserved_listings = []
  	@reservations = Reservation.all

  	@reservations.map do |r|
  		@reserved_listings << r.listing_id
  	end

  	@reserved_listings = @reserved_listings.uniq
  	@start_date = Date.parse(start_date)
  	@end_date = Date.parse(end_date)

  	@listings.map do |l|
  		if !@reserved_listings.include?(l.id)
  			@open_listings << l.id
  		else
  			@reservations.map do |r|
  				if ((r.checkin >= @end_date) || (r.checkout <= @start_date))
  					@open_listings << r.listing_id
  				else
  					@closed_listings << r.listing_id
  				end
  			end
  		end
  	end

  	@open_listings = @open_listings.uniq - @closed_listings.uniq

  	@open_listings.map do |i|
  		Listing.find_by_id(i)
  	end

  end

	def self.highest_ratio_res_to_listings
  	res_ratio = []
  	@neighborhoods = Neighborhood.all
  	@reservations = Reservation.all
  	@listings = Listing.all

  	@neighborhoods.map do |n|
    	neighborhood_reservations = []
   		neighborhood_listings = []

    	@reservations.map do |r|
      	if r.listing.neighborhood.name == n.name
       		neighborhood_reservations << r
      	else
         neighborhood_reservations
        end
      end

   		@listings.map do |l|
       	if l.neighborhood.name == n.name
       		neighborhood_listings << l
      	else
        	neighborhood_listings
        end
     	end

  		if neighborhood_listings.count > 0 
    		ratio = (neighborhood_reservations.count.to_f)/(neighborhood_listings.count)
    	else 
       ratio = 0
    	end

   		res_ratio << ratio
   	end
   		 max_index = res_ratio.index(res_ratio.max)
   		@neighborhoods[max_index]

  end

def self.most_res
  	res_count_array = []
  	@neighborhoods = Neighborhood.all
  	@reservations = Reservation.all

  	@neighborhoods.map do |n|

    	neighborhood_reservations = []
   	
    	@reservations.map do |r|
      	if r.listing.neighborhood.name == n.name
       		neighborhood_reservations << r
      	else
         neighborhood_reservations
        end
      end

      res_count = neighborhood_reservations.count
      res_count_array << res_count

    end

    most_res_index = res_count_array.index(res_count_array.max)
    @neighborhoods[most_res_index]


  end

end
