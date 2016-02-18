class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_date, end_date)
     parsed_start = Date.parse(start_date)
     parsed_end = Date.parse(end_date)
     openings = []
     listings.each do |listing|
        blocked = listing.reservations.any? do |r|
          parsed_start.between?(r.checkin, r.checkout) || parsed_end.between?(r.checkin, r.checkout)
        end
        unless blocked
          openings << listing
        end
      end
      return openings
  end

  def self.highest_ratio_res_to_listings
    popular_city = City.create(:name => "There is no popular city")
    highest_ratio = 0.00
    self.all.each do |city|
      denominator = city.listings.count
      numerator = city.reservations.count
      if denominator == 0 || numerator == 0
        next
      else
        popularity_ratio = numerator /denominator
          if popularity_ratio > highest_ratio
            highest_ratio = popularity_ratio
            popular_city = city
          end
      end
    end
    return popular_city
  end
  
  def self.most_res
    popular_city = City.create(:name => "There is no popular city")
    highest_reservation_count = 0
    self.all.each do |city|
      reservation_count = city.reservations.count
      if reservation_count == 0
        next
      else
        if reservation_count > highest_reservation_count
          highest_reservation_count = reservation_count
          popular_city = city
        end
      end
    end
    return popular_city
  end


end

