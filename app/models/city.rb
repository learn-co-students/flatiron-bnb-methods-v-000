class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    available = []
    listings.map do |listing|
      if listing.reservations.none? { |reserv|  reserv.checkin.between?(start_date, end_date) && reserv.checkout.between?(start_date, end_date)}
        available << listing
      end
    end
    available
  end

  def self.highest_ratio_res_to_listings
    highest_ratio_city =""
    highest_ratio = 0

    self.all.map do |city|
      listings_number = city.listings.count
      reservations_number = city.listings.map { |listing| listing.reservations}.flatten.count
      city_ratio = reservations_number/listings_number

        if city_ratio > highest_ratio
          highest_ratio_city = city
          highest_ratio = city_ratio
        end
      end
      highest_ratio_city
    end

    def self.most_res
    most_res_city = ""
    most_res = 0

    self.all.map do |city|
      reservations_num = city.listings.map { |listing| listing.reservations}.flatten.count

      if reservations_num  > most_res
        most_res_city = city
        most_res = reservations_num 
      end
    end
    most_res_city
  end
end

