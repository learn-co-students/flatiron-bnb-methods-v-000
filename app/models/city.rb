class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    self.listings.each do |listing|
      listing.reservations.collect do |res|
        if res.checkin <= end_date.to_date && res.checkout >= start_date.to_date
          listing
        end
      end
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by do |city| 
      city.listings.map {|listing| listing.reservations.count}.sum/city.listings.count
    end
  end

  def self.most_res
    self.all.max_by do |city|
      city.listings.map {|listing| listing.reservations.count}.sum
    end
  end



end

