class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(begin_date, end_date)
    city_listings = []
    Listing.all.each do |l|
      if !l.reservations.empty?
        none = l.reservations.all.any? do |res|
          r = res.checkin.strftime('%Y-%m-%d')
          s = res.checkout.strftime('%Y-%m-%d')
          (begin_date..end_date).overlaps?(r..s)
        end
        if none == false && l.neighborhood.city == self
          city_listings << l unless city_listings.include?(l)
        end
      elsif !city_listings.include?(l) && l.neighborhood.city == self
        city_listings << l
      end
    end
    city_listings
  end

  def self.highest_ratio_res_to_listings
    ratios = {}
    res_total_by_city.each do |city, res_count|
      current_city = City.find_by_name(city)
      ratios[city] = (res_count / current_city.listings.all.size)
    end
    City.find_by_name(ratios.key(ratios.values.max))
  end

  def self.most_res
    City.find_by_name(res_total_by_city.key(res_total_by_city.values.max))
  end

  def self.res_total_by_city
    ratios = {}
    x = self.all.map do |c|
      ratios[c.name]=c.listings.all.map do |l|
        l.reservations.size
      end
    end
    ratios.each do |city, array|
      ratios[city] = array.inject(0){|sum, x| sum + x}
    end
  end
end
