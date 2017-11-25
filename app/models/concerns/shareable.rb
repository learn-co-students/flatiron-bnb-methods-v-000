module Shareable
  extend ActiveSupport::Concern

  def ratio_res_to_listings
    if listings.count > 0
      reservations.count / listings.count
    else
      0
    end
  end


  class_methods do

    def highest_ratio_res_to_listings
      self.all.max do |a,b|
        a.ratio_res_to_listings <=> b.ratio_res_to_listings
      end
    end

    def most_res
      self.all.max {|a, b| a.reservations.count <=> b.reservations.count}
    end
  end
end