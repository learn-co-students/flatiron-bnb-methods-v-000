class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

	def neighborhood_openings(start_date, end_date)
		self.listings.find_all {|l| l.available?(start_date, end_date)}
	end
	
	def self.most_res
		all.max_by {|city| city.total_reservations}
  end

  def total_reservations
		self.listings.inject(0) do |sum, listing|
      sum + listing.reservations.count
    end
  end

  def self.highest_ratio_res_to_listings
    all_neighborhoods = []
    all.each do |neighborhood|
      if neighborhood.total_reservations != 0 && neighborhood.listings.count != 0
        all_neighborhoods << neighborhood
      end
    end
    all_neighborhoods.max_by do |neighborhood|
      neighborhood.total_reservations/neighborhood.listings.count
    end
  end
end
