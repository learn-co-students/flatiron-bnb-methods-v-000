module Shareable
  extend ActiveSupport::Concern

  module InstanceMethods

    def overlap(checkin, checkout)
      listings.find_all do |listing|
        listing.reservations.all? do |res|
          checkin.to_datetime >= res.checkout || checkout.to_datetime <= res.checkin
        end
      end
    end

    def ratio
      if listings.count > 0
        reservations.count.to_f / listings.count.to_f
      else
        0
      end
    end

  end

  module ClassMethods

    # a = %w(albatross dog horse)
    # a.max #=> "horse"
    # a.max { |a, b| a.length <=> b.length }  #=> "albatross"
    
    def highest_ratio_res_to_listings
      all.max { |x, y| x.ratio <=> y.ratio }
    end

    def most_res
      all.max {|x, y| x.reservations.count <=> y.reservations.count}
    end
  end
end
