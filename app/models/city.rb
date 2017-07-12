class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  def city_openings(date1, date2)
    date1 = Date.parse(date1)
    date2 = Date.parse(date2)

    listings.select do |list|
      list if list.reservations.all? { |res| res.checkout <= date1 || res.checkin >= date2 }
    end
  end

  def self.highest_ratio_res_to_listings
    highest_res_city = nil
    high_res_ratio = 0

    all.each do |city|
      listing_count = city.listings.count
      reservation_count = 0
      current_ratio = 0

      city.listings.each { |listing| reservation_count += listing.reservations.count }
      current_ratio = reservation_count / listing_count unless listing_count == 0

      if high_res_ratio < current_ratio
        high_res_ratio = current_ratio
        highest_res_city = city
      end
    end
    highest_res_city
  end

  def self.most_res
    most_res_city = nil
    most_res = 0

    all.each do |city|
      reservation_count = 0
      city.listings.each { |listing| reservation_count += listing.reservations.count }

      if most_res < reservation_count
        most_res = reservation_count
        most_res_city = city
      end
    end
    most_res_city
  end
end
