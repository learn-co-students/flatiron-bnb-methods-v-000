class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
  	start_date =Date.parse(start_date)
  	end_date = Date.parse(end_date)

  	self.listings.select do |listing|
  		listing.reservations.empty? ||
  		listing.reservations.all? do |reservation|
  			reservation.checkin >=end_date || reservation.checkout <= start_date
  		end
  	end
  end

  def self.highest_ratio_res_to_listings	
  	Neighborhood.all.reject {|n| n.listings.empty?}.max_by do |neighborhood|
  		neighborhood.listings.inject(0) {|sum,listing| sum + listing.reservations.count} / neighborhood.listings.count
  	end
  end

  def self.most_res
  	Neighborhood.all.max_by do |neighborhood|
  		neighborhood.listings.inject(0) { |sum, listing| sum + listing.reservations.count}
  	end
  end



end
