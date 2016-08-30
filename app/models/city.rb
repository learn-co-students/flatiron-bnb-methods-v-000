class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def self.highest_ratio_res_to_listings
    # binding.pry
    city_ratios = {}
    ratio = self.all.collect do |c|
      listing_count     = c.listings.count
      reservations = []
      c.listings.each do |l|
        l.reservations.each do |r|
          reservations << r
        end
      end
      city_ratios[(reservations.count / listing_count.to_f)] = c
      (reservations.count / listing_count.to_f)
    end.max
    city_ratios[ratio]
  end

  def self.most_res
    city_reservations = {}
    most_reservations = self.all.collect do |c|
      reservations = []
      c.listings.each do |l|
        l.reservations.each do |r|
          reservations << r
        end
      end
      city_reservations[c] = reservations.count
      reservations.count
    end.max
    city_reservations.select{|city, res_count| res_count == most_reservations}.keys[0]
  end

  def city_openings(start, enddate)
    range = (start.to_date)..(enddate.to_date)
    listing_list = []
    self.listings.collect do |listing|
      has_openings = !listing.reservations.any? do |reservation|
        res_range = reservation.checkin..reservation.checkout
        range === res_range
      end
      if has_openings
        listing
      end
    end
  end
end
