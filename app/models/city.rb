class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(date1, date2)

    arr = []
    range = Date.parse(date1)..Date.parse(date2)

    self.listings.each do |listing|
      arr << listing
    end

    self.listings.each do |l|
      l.reservations.each do |r|
        if range.cover?(r.checkin) || range.cover?(r.checkout)
          arr.delete(l)
        end
      end
    end
    arr
  end

  def self.highest_ratio_res_to_listings
    self.all.max do |a_city, b_city|
      (a_city.reservations.count/a_city.listings.count) <=> (b_city.reservations.count/b_city.listings.count)
    end
  end

  def self.most_res
    self.all.max do |a_city, b_city|
      a_city.reservations.count <=> b_city.reservations.count
    end
  end


end
