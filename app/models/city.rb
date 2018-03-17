class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_date, end_date)
      Listing.select { |listing| listing.reservations.select { |r| r.checkin > Date.parse(start_date) && r.checkout < Date.parse(end_date)}}
  end

  def self.highest_ratio_res_to_listings
      @city = City.all.max_by { |city| city.ratio }
  end

  def self.most_res
      @city = City.all.max_by { |city| city.reservations.count }
  end

  def ratio
      self.reservations.count/self.listings.count
  end

end
