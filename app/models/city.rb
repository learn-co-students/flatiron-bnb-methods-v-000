class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def self.most_res
    top_city = self.all[0]
    self.all.each do |city|
      if city.reservations.count > top_city.reservations.count
        top_city = city
      end
    end
    top_city
  end

  def self.highest_ratio_res_to_listings
    top_city = self.all[0]
    self.all.each do |city|
      if (city.reservations.count.to_f/city.listings.count.to_f) > (top_city.reservations.count.to_f/top_city.listings.count.to_f)
        top_city = city
      end
    end
    top_city
  end

  def city_openings(start_date, end_date)
    available = self.listings.select do |listing|
      listing.reservations.none? do |reservation|
        !((end_date.to_datetime <= reservation.checkin) || (start_date.to_datetime >= reservation.checkout))
      end
    end
    available
  end

end
