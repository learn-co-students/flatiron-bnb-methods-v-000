class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
    self.listings.each do |list|
      list.reservations.collect do |res|
        if res.checkin == start_date && res.checkout == end_date
          list
        end
      end
    end
  end

  def self.highest_ratio_res_to_listings
    all.max do |a, b|
      a.ratio_res_to_listings <=> b.ratio_res_to_listings
    end
  end

  def self.most_res
    all.max do |a, b|
      a.reservations.count <=> b.reservations.count
    end
  end

  def ratio_res_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    end
  end

end
