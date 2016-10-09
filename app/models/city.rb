class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)

  listings
  end

  def find_ratio
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    end
  end

  def self.highest_ratio_res_to_listings
      City.all.max do |a, b|
        a.find_ratio <=> b.find_ratio
      end
  end

  def self.most_res
    City.all.max do |a, b|
      a.reservations.count <=> b.reservations.count
    end
  end


end
