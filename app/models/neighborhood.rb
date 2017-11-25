class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  extend Location

  def neighborhood_openings(start_date, end_date) 
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
    @loc = nil
    Neighborhood.find_each do |loc| 
      if loc.listings.count > 0
        @ratio = loc.num_reservations.to_f / loc.listings.count
        if @ratio > @max
          @max = @ratio
          @loc = loc 
        end
      end
    end
    @loc
  end
 
  def self.most_res
    @max = -100 
    @loc = nil
    Neighborhood.find_each do |loc| 
      if (loc.num_reservations >= @max)
        @max = loc.num_reservations
        @loc = loc 
      end
    end
    @loc
  end

end
