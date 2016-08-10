class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def self.highest_ratio_res_to_listings
    ratios = Hash.new
    City.all.each do |c|
      ratios[c] = (c.reservations.count/c.listings.count)
    end
    (ratios.max_by{|k,v| v})[0]
  end

  def self.most_res
    City.joins(:reservations).
    select('cities.*, count(reservations.id) AS reservations_count').
    group("cities.id").
    order("reservations_count DESC").
    first
  end


  def city_openings(start_s, end_s)
    start_d = Date.parse(start_s)
    end_d = Date.parse(end_s)
    available_res = self.listings
    self.listings.each do |l|
      l.reservations.each do |r|
        if start_d <= r.checkout && r.checkin <= end_d
          available_res - [l]
          break
        end
      end
    end
    available_res
  end

end
