class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_time, end_time)
     start_date = Date.parse(start_time)
     end_date = Date.parse(end_time)
     vacant_listings = []
     listings.each do |listing|
        occupied = listing.reservations.any? do |n|
          start_date.between?(n.checkin, n.checkout) || end_date.between?(n.checkin, n.checkout)
        end
        unless occupied
          vacant_listings << listing
        end
      end
      return vacant_listings
  end

  def self.highest_ratio_res_to_listings
    popular_city = "There is no popular city."
    popularity_ratio = 0.00
    self.all.each do |city|
      denominator = city.listings.count
      numerator = city.reservations.count
      if numerator == 0 || denominator == 0
        return popular_city
      else
        city_ratio = numerator / denominator
        if city_ratio > popularity_ratio
          popularity_ratio = city_ratio
          popular_city = city
        end
      end
    end
    popular_city
  end

  def self.most_res
    most_res = 0
    most_res_area = self.first
    self.all.each do |area|
      area.reservations.count
      if area.reservations.count > most_res
        most_res = area.reservations.count
        most_res_area = area
      end
    end
    most_res_area
  end
end

