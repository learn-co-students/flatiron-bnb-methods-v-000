class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

	# @city = City.find_by_id
 #  @city_listings = @city.listings #get all the listings for a city


  def city_openings(start_date, end_date)
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
  	@cities = City.all
  	@reservations = Reservation.all
  	@listings = Listing.all

  	@cities.map do |c|
    	city_reservations = []
   		city_listings = []

    	@reservations.map do |r|
      	if r.listing.neighborhood.city.name == c.name
       		city_reservations << r
      	else
         city_reservations
        end
      end

   		@listings.map do |l|
       	if l.neighborhood.city.name == c.name
       		city_listings << l
      	else
        	city_listings
        end
     	end

  		if city_listings.count > 0 
    		ratio = (city_reservations.count.to_f)/(city_listings.count)
    	else 
       ratio = 0
    	end

   		res_ratio << ratio
   	end
   		 max_index = res_ratio.index(res_ratio.max)
   		@cities[max_index]

  end

  def self.most_res
  	res_count_array = []
  	@cities = City.all
  	@reservations = Reservation.all

  	@cities.map do |c|

    	city_reservations = []
   	
    	@reservations.map do |r|
      	if r.listing.neighborhood.city.name == c.name
       		city_reservations << r
      	else
         city_reservations
        end
      end

      res_count = city_reservations.count
      res_count_array << res_count

    end

    most_res_index = res_count_array.index(res_count_array.max)
    @cities[most_res_index]


  end

end

