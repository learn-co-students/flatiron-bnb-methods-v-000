class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(date_1, date_2)
    start_date = Date.parse(date_1)
    end_date = Date.parse(date_2)
    available_listings = []

    listings.each do |listing|
      unless listing.reservations.any? { |res| start_date.between?(res.checkin, res.checkout) || end_date.between?(res.checkin, res.checkout) }
        available_listings << listing
      end
    end
    available_listings
  end

  def self.highest_ratio_res_to_listings
    city_res_count = 0
    high_ratio = nil
    self.all.each do |city|
      city.listings.each do |listing|
        if city_res_count < listing.reservations.count
          city_res_count = listing.reservations.count
          high_ratio = city
        end
      end
    end
    high_ratio
  end

  def self.most_res
    city_res_count = 0
    most_res = nil
    self.all.each do |city|
      city.listings.each do |listing|
        if city_res_count < listing.reservations.count
          city_res_count = listing.reservations.count
          most_res = city
        end
      end
    end
    most_res
  end

end
