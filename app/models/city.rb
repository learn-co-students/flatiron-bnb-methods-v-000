class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date,end_date)
  	self.listings.select do |listing|
  		listing.reservations.all? do |reservation| 
  			reservation.checkin > DateTime.parse(end_date) || reservation.checkout < DateTime.parse(start_date)
  		end
  	end
  end 

  def self.highest_ratio_res_to_listings
  	ratioArray = self.all.map {|city|
  		ratioHash = { id: city.id, ratio: -1}
  		listingsCount = city.listings.count
  		reservationsCount = listingsCount == 0 ? 0 : city.listings.map {|listing| listing.reservations.count}.reduce(:+)
  		ratioHash[:ratio] = listingsCount == 0 ? -1 : reservationsCount/listingsCount
  		ratioHash
		}
		maxHash = ratioArray.max {|a,b| a[:ratio] <=> b[:ratio]}
		self.find(maxHash[:id])
  end

  def self.most_res
  	reservationsArray = self.all.map {|city|
  		reservationsHash = {id: city.id, reservations: 0}
  		listingsCount = city.listings.count
  		reservationsHash[:reservations] = listingsCount == 0 ? 0 : city.listings.map {|listing| listing.reservations.count}.reduce(:+)
  		reservationsHash  		
  	}
		maxHash = reservationsArray.max {|a,b| a[:reservations] <=> b[:reservations]}
		self.find(maxHash[:id])
  end
end

