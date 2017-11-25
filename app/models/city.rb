class City < ActiveRecord::Base
  include SharedMethods
  extend SharedMethods
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date1, date2)
    openings(date1, date2)
  end

  def self.highest_ratio_res_to_listings
    h_ratio_res_to_listings
  end

  def self.most_res
    # select cities.id, count listing_id's in reservations under column listing_count
    # inner join neigborhoods => listings => reservations (has listing_id)
    # group by city_id in listings
    # order by listing_count, limit 1

    city = select("cities.id, count(listing_id) AS listing_count").joins(:listings => :reservations).group(:city_id).order("listing_count DESC").limit(1)

    self.find(city.first.id)
  end

end

