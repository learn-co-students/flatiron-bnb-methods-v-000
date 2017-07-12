class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    listings.includes(:reservations).select do |listing|
      listing.reservations.none? do |reservation|
        reservation.checkin <= end_date && start_date <= reservation.checkout
      end
    end
  end

  def self.highest_ratio_res_to_listings
    cities = City.includes(listings: [:reservations]).all

    cities.collect do |city|
      total_listings = city.listings.count
      total_reservations = city.listings.reduce(0) do |memo, listing|
        memo += listing.reservations.count
      end

      {city: city, ratio: total_reservations / total_listings.to_f}
    end.max_by { |x| x[:ratio] }[:city]
  end

  def self.most_res
    cities = City.includes(listings: [:reservations]).all

    cities.collect do |city|
      total_res = city.listings.reduce(0) do |memo, listing|
        memo += listing.reservations.count
      end

      {city: city, total_res: total_res}
    end.max_by { |x| x[:total_res] }[:city]
  end
end

