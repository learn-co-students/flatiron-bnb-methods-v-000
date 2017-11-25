class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_date, end_date)
    range = Date.parse(start_date)...Date.parse(end_date)
    output = []

    Listing.all.each do |listing|
      if listing.reservations == []
        output << listing
      end
      listing.reservations.each do |reservation|
        if !range.include?(reservation.checkin) && !range.include?(reservation.checkout)
          output << listing
        end
      end

    end
    output.uniq
  end

  def self.highest_ratio_res_to_listings
    current = 0
    output = nil
    City.all.each do |city|
      if city.reservations.count/city.listings.count > current
        current = city.reservations.count/city.listings.count
        output = city
      end
    end
    output
  end

  def self.most_res
    current = 0
    output = nil
    City.all.each do |city|
      if city.reservations.count > current
        current = city.reservations.count
        output = city
      end
    end
    output
  end

end

