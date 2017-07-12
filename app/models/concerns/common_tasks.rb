module CommonTasks
  module InstanceMethods
    # Format "year-month-day"
    def make_date_from_str(str)
      Date.new(*str.split("-").map { |el| el.to_i })
    end

    def openings(date_1, date_2)
      starts_at = make_date_from_str(date_1)
      ends_at = make_date_from_str(date_2)

      self.listings.select do |listing|
        listing.available?(starts_at, ends_at)
      end
    end
  end

  module ClassMethods

    def highest_ratio_res_to_listings
      self.all.max_by do |city|
        city.listings.reduce(0) { |sum, listing| sum + listing.reservations.size }
      end
    end

    def most_res
      self.all.max_by do |el|
        el.reservations.count
      end
    end

  end
end
