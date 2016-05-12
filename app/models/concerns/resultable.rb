module Resultable
  module InstanceMethods
    def openings(start_date, end_date)
      requested_dates = start_date..end_date
      openings = self.listings.collect do |listing|
        listing unless listing.reservations.any? do |reservation|
          requested_dates === start_date || requested_dates === end_date
        end
      end
    end
  end

  module ClassMethods
    def self.highest_ration_res_to_listings
      
    end

    def self.most_res
      
    end
  end
end