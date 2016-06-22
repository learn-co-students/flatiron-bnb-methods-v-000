class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def self.highest_ratio_res_to_listings
    hash = {}
    self.all.each do |neighborhood|
      res_count=0
      neighborhood.listings.each do |listing|
        res_count += listing.reservations.count
      end
      ratio = 0
      ratio = res_count / neighborhood.listings.count unless neighborhood.listings.count == 0
      hash[neighborhood.id] = ratio
    end
    Neighborhood.find(hash.max_by{|k,v| v}.first)
  end
  
  def self.most_res
    hash = {}
    self.all.each do |neighborhood|
      res_count=0
      neighborhood.listings.each do |listing|
        res_count += listing.reservations.count
      end
      hash[neighborhood.id] = res_count
    end
    Neighborhood.find(hash.max_by{|k,v| v}.first)
  end
  
  def neighborhood_openings(t1,t2)
    arr=[t1,t2]
    self.listings.each do |listing| 
      arr << listing if listing.is_available?(t1,t2)
    end
    arr
  end
  
end
