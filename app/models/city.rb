class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings 

  def city_openings(start_date, end_date)
    openings = [] 
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    listings.each do |l| 
       openings << l if !l.reservations.any? {|reservation| reservation.checkin <= end_date && reservation.checkout >= start_date }
    end 
    openings 
  end 

  def self.highest_ratio_res_to_listings
    cities = City.all.sort_by {|c| c.reservations.count.to_f / c.listings.count.to_f}
    highest_ratio = cities.last 
  end 

  def self.most_res 
    cities = City.all.sort_by {|c| c.reservations.count}
    highest = cities.last 
  end 
  
  

end

