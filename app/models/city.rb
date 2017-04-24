class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  def city_openings(checkin, checkout)
    availables = self.listings.collect{|a| a}
    self.listings.each do |listing|
      listing.reservations.each do |res|
        if (Date.parse(checkin) > res.checkin && Date.parse(checkin) < res.checkout) || (Date.parse(checkout) > res.checkin && Date.parse(checkout) < res.checkout)
          availables.delete(listing)
        end
      end
    end
    availables
  end

  def self.highest_ratio_res_to_listings
    highest = City.first
    self.all.each do |city|
      highest = city if city.ratio > highest.ratio
    end
    highest
  end

  def listings_count
    self.listings.count
  end

  def res_count
    count = 0
    self.listings.each {|res| count += 1}
    count
  end

  def ratio
    self.res_count/self.listings_count
  end

end
