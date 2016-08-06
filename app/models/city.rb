class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :reservations, :through => :listings
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    self.listings.each do |listing|
      listing.reservations.collect do |res|
        if res.checkin == start_date && res.checkout == end_date
          listing
        end
      end
    end
  end

  #class methods
  def self.highest_ratio_res_to_listings
    self.all.max_by do |place| 
      if place.listings.count == 0
        0
      else
        place.listings.map{|l| l.reservations.count}.sum / place.listings.count
      end
    end
  end
 
  def self.most_res
    all.max do |a, b|
      a.reservations.count <=> b.reservations.count
    end
  end
  
  def ratio_res_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    end
  end  
end

