class City < ActiveRecord::Base
	has_many :neighborhoods
	has_many :listings, :through => :neighborhoods
	has_many :reservations, through: :listings

	def city_openings(date_1, date_2)
		start_date = Date.parse(date_1)
		end_date = Date.parse(date_2)
		open_listings = []
		listings.each do |listing|
			taken = listing.reservations.any? do |reservation|
				start_date.between?(reservation.checkin, reservation.checkout) || end_date.between?(reservation.checkin, reservation.checkout)
			end
			unless taken
				open_listings << listing	
			end
		end
		open_listings
	end

	def self.highest_ratio_res_to_listings
		popular_city = City.create(name: "There is no most popular city")
		highest_ratio = 0
		self.all.each do |city|
			num_reservations = city.reservations.count
			num_listings = city.listings.count
			if num_reservations == 0 || num_listings == 0
				next
			else
				ratio = num_reservations / num_listings
				if ratio > highest_ratio
					highest_ratio = ratio
					popular_city = city
				end	
			end
		end
		popular_city
	end

	def self.most_res
		most_popular = City.create(name: "No city has the most reservations")
		most_reservations = 0
		self.all.each do |city|
			if city.reservations.count > most_reservations
				most_reservations = city.reservations.count
				most_popular = city
			end
		end
		most_popular
	end

end

