module Cityhoods
	extend ActiveSupport::Concern

	def openings(in_date, out_date)
		self.listings.where((in_date..out_date).any? == false)
	end
end

module ClassMethods

	def highest_ratio_res_to_listings
		@holder = []
		self.all.each do |c|
			if c.listings.count > 0
				@holder << c
			end
		end
		@holder.max_by do |x|
  			x.reservations.count/x.listings.count
  		end
	end

	def most_res
		self.all.max_by {|x| x.reservations.count}
	end

end