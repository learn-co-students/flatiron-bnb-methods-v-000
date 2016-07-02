class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start, finish)
    start_date = Date.parse(start)
    end_date = Date.parse(finish)
    
    avail = []
    
    avail = listings.reject do |listing|
      listing.reservations.any? {|res| start_date.between?(res.checkin, res.checkout) || end_date.between?(res.checkin, res.checkout)}
    end.flatten
  end
  
  def self.highest_ratio_res_to_listings
    highest_ratio = 0/1
    
    self.all.each do |city|
      city_ratio = city.ratio_res_to_listings
      highest_ratio =  city_ratio if city_ratio > highest_ratio
    end
    
    self.all.detect {|city| city.ratio_res_to_listings == highest_ratio}
  end
  
  def self.most_res
    max = 0
    self.all.each {|city| max = city.res_count if city.res_count > max}
    self.all.detect {|city| city.res_count == max}
  end
  
  def ratio_res_to_listings
    res_count.to_f / listings.count.to_f   
  end
  
  def res_count
    res = 0
    listings.each {|l| res += l.reservations.count}
    res
  end

end

