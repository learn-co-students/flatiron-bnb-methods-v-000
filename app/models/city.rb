class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  

  def city_openings(start_date, end_date)
    Listing.all.each do |listing|
      listing.reservations.each do |res|
        start_date <= res.checkout.to_s && end_date >= res.checkin.to_s
      end
    end
  end

  def self.highest_ratio_res_to_listings
      ratios = {}
      self.all.each do |city|
        counter = 0
        city.listings.each do |a|
          counter += a.reservations.count
        end
        ratios[city] = (counter)/(city.listings.count)
      end
      ratios.key(ratios.values.sort.last)
  end

  def self.most_res
    res = {}
    self.all.each do |city|
      counter = 0
      city.listings.each do |a|
        counter += a.reservations.count
      end
      res[city] = counter
    end
    res.key(res.values.sort.last)
  end




end