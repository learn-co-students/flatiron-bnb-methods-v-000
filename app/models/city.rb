class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

#private

  def city_openings(date_start, date_end)
    self.listings.each do |listing|
      listing.reservations.collect do |reservation|
        if reservation.checkin == date_start && reservation.checkout == date_end
          listing
        end
      end
    end
  end

  def self.highest_ratio_res_to_listings
    city_res_count = 0
    high_ratio = nil
    self.all.each do |city|
      city.listings.each do |listing|
        if city_res_count < listing.reservations.count
          city_res_count = listing.reservations.count
          high_ratio = city
        end
      end
    end
    high_ratio
  end

  def self.most_res
    city_res_count = 0
    most_res = nil
    self.all.each do |city|
      city.listings.each do |listing|
        if city_res_count < listing.reservations.count
          city_res_count = listing.reservations.count
          most_res = city
        end
      end
    end
    most_res
  end
 

end
