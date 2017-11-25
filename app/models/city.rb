class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

	def city_openings(startdate, enddate)
    self.listings.find_all {|l| l.available?(startdate, enddate)}
  end
	
	def self.most_res
    City.all.max_by {|city| city.total_reservations}
  end

  def total_reservations
		self.listings.inject(0) do |sum, listing|
      sum + listing.reservations.count
    end
  end

  def self.highest_ratio_res_to_listings
    City.all.max_by {|city| city.total_reservations/city.listings.count}
  end

	
end

