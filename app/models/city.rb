class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date1, date2)
    self.listings.find_all{|listing| listing.available?(date1, date2)}
  end


  def total_reservations  
    self.listings.inject(0) {|sum, listing| sum + listing.reservations.count}
  end

  def self.highest_ratio_res_to_listings
    City.all.max_by {|city| city.total_reservations/city.listings.count}
  end

  def self.most_res
    City.all.max_by {|city| city.total_reservations}
  end

end

