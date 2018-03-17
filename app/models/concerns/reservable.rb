module Reservable
  extend ActiveSupport::Concern

  def openings(start_date, end_date)
    listings.collect{|l| l if l.available?(Date.parse(start_date), Date.parse(end_date))}
  end

  def res_to_listings_ratio
    listings.count > 0 ? (reservations.count.to_f / listings.count) : 0
  end

  class_methods do
    def highest_ratio_res_to_listings
      all.sort{|a,b| a.res_to_listings_ratio <=> b.res_to_listings_ratio}.last
    end

    def most_res
      all.max{|a,b| a.reservations.count <=> b.reservations.count}
    end
  end
end
