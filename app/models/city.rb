class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  
  def city_openings(t1,t2)
    arr=[t1,t2]
    self.listings.each do |listing| 
      arr << listing if listing.is_available?(t1,t2)
    end
    arr
  end
  
  def self.most_res
    hash = {}
    self.all.each do |city|
      res_count=0
      city.listings.each do |listing|
        res_count += listing.reservations.count
      end
      hash[city.id] = res_count
    end
    City.find(hash.max_by{|k,v| v}.first)
  end
  
  def self.highest_ratio_res_to_listings
    hash = {}
    self.all.each do |city|
      res_count=0
      city.listings.each do |listing|
        res_count += listing.reservations.count
      end
      ratio = res_count / city.listings.count
      hash[city.id] = ratio
    end
    City.find(hash.max_by{|k,v| v}.first)
  end

end

