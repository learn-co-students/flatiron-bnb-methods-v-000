class Neighborhood < ActiveRecord::Base
  belongs_to :city 
  has_many :listings

  def neighborhood_openings(start_date,end_date)
  	self.listings.select do |listing|
  		listing.reservations.all? do |reservation| 
  			reservation.checkin > DateTime.parse(end_date) || reservation.checkout < DateTime.parse(start_date)
  		end
  	end
  end 

  def self.highest_ratio_res_to_listings
  	ratioArray = self.all.map {|neighborhood|
  		ratioHash = { id: neighborhood.id, ratio: -1}
  		listingsCount = neighborhood.listings.count
  		reservationsCount = listingsCount == 0 ? 0 : neighborhood.listings.map {|listing| listing.reservations.count}.reduce(:+)
  		ratioHash[:ratio] = listingsCount == 0 ? -1 : reservationsCount/listingsCount
  		ratioHash
		}
		maxHash = ratioArray.max {|a,b| a[:ratio] <=> b[:ratio]}
		self.find(maxHash[:id])
  end

  def self.most_res
  	reservationsArray = self.all.map {|neighborhood|
  		reservationsHash = {id: neighborhood.id, reservations: 0}
  		listingsCount = neighborhood.listings.count
  		reservationsHash[:reservations] = listingsCount == 0 ? 0 : neighborhood.listings.map {|listing| listing.reservations.count}.reduce(:+)
  		reservationsHash  		
  	}
		maxHash = reservationsArray.max {|a,b| a[:reservations] <=> b[:reservations]}
		self.find(maxHash[:id])
  end
end
