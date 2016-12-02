class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(first, second)
  	self.listings.select { |x| x.reservations.empty? || x.reservations.any? { |y| y.checkin >= second.to_date || y.checkout <= first.to_date } }
  end

  def self.highest_ratio_res_to_listings
  	all = {}
  	self.all.each do |x|
  	res = []
  	listings = x.listings.count
  	x.listings.each do |y|
  		res << y.reservations.count
  	end
  	
  	reservations = res.reduce(:+)
  	
  	all[x]= reservations.to_f / listings.to_f
  	end
  	
  	all.max_by { |x,y| y}[0]
  
  end

  def self.most_res
  	all = {}
  	self.all.each do |x|
  		count = []
  		x.listings.each do |y|
  			count << y.reservations.count
  		end
  	all[x] = count.reduce(:+)
  	end
  	all.max_by { |x,y| y}[0]
  end

end

