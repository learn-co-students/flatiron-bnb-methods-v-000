class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  include Reservable

  def neighborhood_openings(start_date, end_date)
    listings.available_listings_for_dates(start_date, end_date)
  end   

#  def res_to_listings_ratio
#    total_reservations.to_f / listings.count.to_f
#  end
#
#  def total_reservations
#    listings.reduce(0) { |total, listing| listing.reservations.count + total }
#  end
#
#  class << self
#    def highest_ratio_res_to_listings
#      has_listings.max { |a,b| a.res_to_listings_ratio <=> b.res_to_listings_ratio }
#    end
#
#    def most_res
#      has_listings.max { |a,b| a.total_reservations <=> b.total_reservations }
#    end
#
#    def has_listings
#      all.select { |city| city.listings.any? }
#    end
#  end
end
