class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def self.highest_ratio_res_to_listings
  	self.all.max_by do |hood| 
  		reservation_count = hood.listings.inject(0) { |sum, list| sum+=list.reservations.count }
  		listing_count = hood.listings.count
  		(listing_count==0) ? 0 : (reservation_count/listing_count)
  	end
  end

  def self.most_res
  	self.all.max_by do |hood| 
  		hood.listings.inject(0) { |sum, list| sum+=list.reservations.count }
  	end
  end

  def neighborhood_openings(min, max)
  	self.listings.find_all do |listing|
  		listing.reservations.none? do |res| 
  			between_dates?(min:min, max:max, date:res.checkin) || between_dates?(min:min, max:max, date:res.checkout)
  		end
  	end
  end

  def between_dates?(min:, max:, date:) 	
  	Date.parse(date.to_s).between?(Date.parse(min.to_s), Date.parse(max.to_s))
  end

end
