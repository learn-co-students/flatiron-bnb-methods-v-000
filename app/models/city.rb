# City Class
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_date, end_date)
    listings.each do |list|
      list.reservations.collect do |res|
        res.checkin == start_date && res.checkout == end_date
      end
    end
  end

  def self.highest_ratio_res_to_listings
    all.max_by do |city|
      city.reservations.count.to_f / city.listings.count.to_f if city.listings.count > 0
    end
  end

  def self.most_res
    all.max_by { |city| city.reservations.count }
  end
end
