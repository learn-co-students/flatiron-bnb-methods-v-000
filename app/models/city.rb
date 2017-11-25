class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

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
    current_city_reservation_count = 0
    h_r_r_city = nil
    self.all.each do |city|
      city.listings.each do |listing|
        if current_city_reservation_count < listing.reservations.count
          current_city_reservation_count = listing.reservations.count
          h_r_r_city = city
        end
      end
    end
    h_r_r_city
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
