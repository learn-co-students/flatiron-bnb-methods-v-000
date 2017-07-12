class City < ActiveRecord::Base

	include Accom
	extend Accom

	has_many :neighborhoods
	has_many :listings, :through => :neighborhoods
	has_many :reservations, through: :listings

	def city_openings(checkin, checkout)
		openings(checkin, checkout)
	end	

	def self.highest_ratio_res_to_listings
		most_res
	end

	def self.most_res
		city_res = 0
		max_res = most_reservations
		Neighborhood.all.map do |area| 
			if max_res.keys[0] == area.id
				city_res = area.city_id 
			end
		end	
		city = City.all.detect {|city| city if city.id == city_res}	
	end	
end

