class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  

  def city_openings(start_date, end_date)
    @listings = Listing.all

  end

  def self.highest_ratio_res_to_listings
     @cities = City.all
     @cities.max_by do |city|
      city.name
    end
      
  
   
  end




end

