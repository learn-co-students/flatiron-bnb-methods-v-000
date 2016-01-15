class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(range_start,range_end)
    s = Time.parse(range_start)
    e = Time.parse(range_end)
    @available = []
      listings.each do |listing|
        @available << listing unless listing.reservations.any? do |res|
          s.between?(res.checkin,res.checkout) &&
          e.between?(res.checkin,res.checkout)
        end
      end
    @available
  end

  def self.highest_ratio_res_to_listings
    @city_hash = {}
    self.all.each do |city|

      if city.listings.count != 0 && city.reservations.count != 0
        listings_count = city.listings.count
        res_count = city.reservations.count
      
        ratio = res_count/listings_count
        @best_city = city if ratio > (@city_hash.values[0] || 0)
        @city_hash[city] = ratio
      end
    end
    @best_city
  end

  def self.most_res
    @best_res = {"0" => 0}
    self.all.each do |city|
      res_count = city.reservations.count
      @best_res = {city => res_count} if res_count > @best_res.values[0]
    end
    @best_res.keys[0]
  end

end

