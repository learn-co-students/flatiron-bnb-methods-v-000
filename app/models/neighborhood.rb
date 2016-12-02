class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(date1, date2)
  	self.listings.select do |y|
  		y.reservations.any? do |x|
  			x.checkin > date2.to_date  || x.checkout = date1.to_date || x.checkin.nil? 
  		end
  	end
  end
  
  def self.highest_ratio_res_to_listings
  	all = {}
  	self.all.each do |x|
  		count_list = x.listings.count
  		count_res_a = []
  		x.listings.each do |y|
  			
  			count_res_a << y.reservations.count
  		end
  		count_res = count_res_a.reduce(:+)
  		all[x] = count_res.to_f / count_list
  		all[x] = 0 if all[x].nan?
  	end	
  	all.max_by { |x,y| y}[0] 
  end
  
 def self.most_res
 	all = {}
 	self.all.each do |x|
 		res = []
 		x.listings.each do |y|
 			res << y.reservations.count
 		end
 		reservations = res.reduce(:+)
 		all[x] = reservations
 		all[x] = 0 if all[x].nil?
 	end
 	all.max_by { |x,y| y }[0]
 end

end
