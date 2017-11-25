module Ratios
  extend ActiveSupport::Concern

  def ratio
    if listings.count == 0
      0
    else
      reservations.count.to_f / listings.count.to_f
    end
  end

  class_methods do

    def highest_ratio_res_to_listings
      all.max do |a, b|
        a.ratio <=> b.ratio
      end
    end

    def most_res
      all.max do |a, b|
        a.reservations.count <=> b.reservations.count
      end
    end

  end


end
