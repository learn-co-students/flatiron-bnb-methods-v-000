class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

def city_openings(res_start, res_end)
  listings.each do |listing|
      listing.reservations.collect do |reservation|
        if reservation.checkin == res_start && reservation.checkout == res_end
          listing
        end
      end
    end
  end

  def self.highest_ratio_res_to_listings
    res_count = 0
    highest_res_count_city = nil
    self.all.each do |city|
      city.listings.each do |listing|
        if res_count < listing.reservations.count
          res_count = listing.reservations.count
          highest_res_count_city = city
        end
      end
    end
    highest_res_count_city
  end

  def self.most_res
    self.all.max_by do |city|
      number_of_reservations = 0
      city.listings.each do |listing|
        number_of_reservations += listing.reservations.size
      end
      number_of_reservations
    end
  end

end



