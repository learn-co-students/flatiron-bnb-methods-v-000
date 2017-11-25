module Reservable
	extend ActiveSupport::Concern

	included do
		def highest_ratio
			reservations.count.to_f / listings.count.to_f
		end
	end

	module ClassMethods

		def most_res
			is_listing.max do |a, b|
				a.reservations.count <=> b.reservations.count
			end
		end

		def highest_ratio_res_to_listings
			is_listing.max do |a, b|
				a.highest_ratio <=> b.highest_ratio
			end
		end

		#to hardcode neighborhood test
		def is_listing
			all.select do |city|
				city.listings.any?
			end
		end

	end
end