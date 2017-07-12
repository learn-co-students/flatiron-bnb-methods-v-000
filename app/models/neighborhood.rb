class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

	def neighborhood_openings(start_date, end_date)
		self.listings.collect do |listing|	
			if listing.reservations.where('checkin <= ? AND checkout >= ?', end_date, start_date).empty?
				listing
			end
		end
	end

	def self.highest_ratio_res_to_listings
		highest_ratio = 0
		highest_nhood = nil

		self.all.each do |nhood|
			res_num = 0
			current_ratio = 0.0
			listing_num = nhood.listings.length

			nhood.listings.each do |listing|
				res_num += listing.reservations.length
			end

			current_ratio = res_num.to_f / listing_num.to_f unless listing_num == 0 || res_num == 0
			if current_ratio > highest_ratio
				highest_ratio = current_ratio
				highest_nhood = nhood
			end
		end

		highest_nhood
	end

	def self.most_res
		highest_res = 0
		highest_nhood = nil

		self.all.each do |nhood|
			res_num = 0
			nhood.listings.each do |listing|
				res_num += listing.reservations.length
			end
			
			if res_num >= highest_res
				highest_res = res_num
				highest_nhood = nhood
			end
		end

		highest_nhood
	end

end
