class Neighborhood < ActiveRecord::Base
	belongs_to :city
	has_many :listings
	has_many :reservations, through: :listings

	def neighborhood_openings(start_date, end_date)
		parsed_start = Date.parse(start_date)
		parsed_end = Date.parse(end_date)
		
		open_places = []
		listings.each do |listing|
			blocked = listing.reservations.any? do |reservation|
				parsed_start.between?(reservation.checkin, reservation.checkout) || parsed_end.between?(reservation.checkin, reservation.checkout)
			end
			unless blocked
				open_places << listing
			end
		end
		open_places
	end

	def self.highest_ratio_res_to_listings
		most_popular = Neighborhood.create(name: "There is no most popular neighborhood")
		highest_ratio = 0

		self.all.each do |neighborhood|
			numerator = neighborhood.reservations.count
			denominator = neighborhood.listings.count
			if numerator == 0 || denominator == 0
				next
			else
				ratio = numerator / denominator
				if ratio >= highest_ratio
					most_popular = neighborhood
					highest_ratio = ratio
				end
			end
		end
		most_popular
	end

	def self.most_res
		most_popular = Neighborhood.create(name: "There is no most popular neighborhood")
		most_res = 0
		self.all.each do |neighborhood|
			res = neighborhood.reservations.count
			if res >= most_res
				most_res = res
				most_popular = neighborhood
			end
		end
		most_popular
	end


end
