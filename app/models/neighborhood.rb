class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  include Reservable

  def neighborhood_openings(startdate, enddate)
    neighborhood_openings = []
    listings.each do |listing|
      neighborhood_openings << listing if !(listing.reservations.any? {|res|
        res.checkin.to_s <= enddate && res.checkout.to_s >= startdate})
    end
    neighborhood_openings
  end

  def self.highest_ratio_res_to_listings
  	neighborhoods_with_reservations = []
	self.all.each do |neighborhood|
		if !neighborhood.reservations.empty? || !neighborhood.listings.empty?
			neighborhoods_with_reservations << neighborhood 
		end
	end		

	neighborhood = neighborhoods_with_reservations.sort_by {|neighborhood|
		neighborhood.reservations.count.to_f / neighborhood.listings.count.to_f}

	neighborhood.reverse.first
  end
  
end
