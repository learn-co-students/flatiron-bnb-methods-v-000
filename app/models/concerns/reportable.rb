module Reportable

  extend ActiveSupport::Concern

  module InstanceMethods

    def openings(checkin, checkout)
      self.reservations.none? do |reso|
        (Date.parse(checkin) <= reso.checkout) && (reso.checkin <= Date.parse(checkout))
      end
    end
    
  end

  module ClassMethods

    def highest_ratio_res_to_listings
      self.all.max_by { |x| x.reservations.count / x.listings.count }
    end

    def most_res
      self.all.max_by { |x| x.reservations.count }
    end

  end

end