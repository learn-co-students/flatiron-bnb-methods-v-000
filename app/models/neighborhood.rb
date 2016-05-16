class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(check_in, check_out)
    self.listings.map do |listing|
      listing
    end
  end

  def self.highest_ratio_res_to_listings
    max_city = ""
    max_ratio = "".to_i
    self.all.each do |city|
      city.listings.each do |listing|
        if listing.reservations.count > max_ratio
          max_ratio = listing.reservations.count
          max_city = city
        end
      end
    end
    max_city
  end

  def self.most_res
    top_city = ""
    city_reservations = {}
    self.all.each do |city|
      city_reservations[city] = city.reservations.count.to_i
    end
    top_city = city_reservations.key(city_reservations.values.sort.last)
  end
end
