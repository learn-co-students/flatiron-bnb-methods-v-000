class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings



  def city_openings(start_date, end_date)
    self.listings.each do |listing|
      listing.reservations.each do |res|
        start_date <= res.checkout.to_s && end_date <= res.checkin.to_s
      end
    end
  end 

  def ratio_res_to_listings
    if listings.count > 0
      reservations.count / listings.count
    else
      0
  end 
  end 

  def self.highest_ratio_res_to_listings
  self.all.max do |a, b|
      a.ratio_res_to_listings <=> b.ratio_res_to_listings
    end
  end 

  def self.most_res
    self.all.max do |a, b|
      a.reservations.size <=> b.reservations.size
    end
  end
end

