class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  
  def city_openings(start_date, end_date)
    @openings = []
    self.listings.each do |l|
      if l.available?(start_date) && l.available?(end_date)
        @openings << l
      end
    end
    @openings
  end

  def reservations
    @reservations = []
    listings.each do |listing|
      listing.reservations.each do |res|
        @reservations << res
      end
    end
    @reservations
  end 
  
  def num_reservations
    reservations.count
  end
  
  private 

  def self.highest_ratio_res_to_listings
    @max = -100
    @city = nil
    City.find_each do |city| 
      @ratio = city.num_reservations.to_f / city.listings.count
      if @ratio > @max
        @max = @ratio
        @city = city
      end
    end
    @city
  end
 
  def self.most_res
    @max = -100 
    @city = nil
    City.find_each do |city| 
      if (city.num_reservations > @max)
        @max = city.num_reservations
        @city = city
      end
    end
    @city
  end

end

