module Bnb
  extend ActiveSupport::Concern

  def available(startdate, enddate)
    listings.map do |listing|
      if listing.available(startdate, enddate)
        listing
      end
    end
  end

  def ratio_resos_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    end
  end


  class_methods do
    def highest_ratio_res_to_listings
      all.max do |a, b|
        a.ratio_resos_to_listings.to_f <=> b.ratio_resos_to_listings.to_f
      end
    end

    def most_res
      all.max do |a, b|
        a.reservations.count <=> b.reservations.count
      end
    end
  end

end
