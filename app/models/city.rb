class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
    self.listings.each do |x|

    end
  end

  def self.most_res
    @cities = City.all.includes(:listings, :reservations)
   
    @cities.each do |city|
      city.listings.each do 
      end
    end
  end

end

