class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
    @listings = Listing.all
  end

  def res_ratio
   reservations.count / listings.count
  end

  def self.highest_ratio_res_to_listings
     @cities = City.all
     @cities.max_by {|city| city.res_ratio}
  end
     
  def highest_res
    reservations.count
  end

  def self.most_res
  City.all.max_by {|city| city.highest_res}
  end


  
   





end

