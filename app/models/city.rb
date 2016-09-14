class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(begin_date, end_date)
    self.listings(created_at: begin_date..end_date)
  end

  def self.highest_ratio_res_to_listings
    highest_ratio = 0
    highest_ratio_city = nil

    self.all.each do |city|
      current_ratio = (city.reservations.all.count.to_f / city.listings.all.count.to_f)
      if highest_ratio < current_ratio
        highest_ratio = current_ratio
        highest_ratio_city = city
      end
    end
    highest_ratio_city
  end

  def self.most_res
    most_reservations_city = nil
    reservations_count = 0

    self.all.each do |city|
      if city.reservations.count > reservations_count
        most_reservations_city = city
        reservations_count = city.reservations.count
      end      
    end
    most_reservations_city
  end

end
