class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
    self.listings.collect do |list|
      list if list.reservations.all? { |res| !((start_date.to_date <= res.checkout) && (res.checkin >= end_date.to_date))}
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.sort { |x, y| (y.reservations.count.to_f / y.listings.count) <=> (x.reservations.count.to_f / x.listings.count) }.first
  end

  def self.most_res
    self.all.sort { |x, y| y.reservations.count <=> x.reservations.count }.first
  end

end

