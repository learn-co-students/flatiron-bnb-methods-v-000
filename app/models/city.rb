class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_date, end_date)
    checkin_dates = [Date.parse(start_date), Date.parse(end_date)]

    all_listings = listings.to_a
    all_listings.delete_if do |listing|
      listing.reservations.any? do |res|
        checkin_dates.any?{|date| (res.checkin..res.checkout).include?(date)}
      end
    end
  end

  def self.highest_ratio_res_to_listings
    most_popular_city = ""
    highest_ratio = 0.00

    all.each do |city|
      city_ratio = city.reservations.count.to_f / city.listings.count
      if city_ratio > highest_ratio
        most_popular_city = city
        highest_ratio = city_ratio
      end
    end
    most_popular_city
  end

  def self.most_res
    most_res_city = ""
    highest_res = 0

    all.each do |city|
      res_count = city.reservations.count
      if res_count > highest_res
        highest_res = res_count
        most_res_city = city
      end
    end
    most_res_city
  end
end
