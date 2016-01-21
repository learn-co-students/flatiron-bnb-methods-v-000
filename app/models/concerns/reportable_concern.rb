module ReportableConcern
  module InstanceMethods
    def city_openings(begin_date, end_date)
      find_openings(begin_date, end_date)
    end

    def neighborhood_openings(begin_date, end_date)
      find_openings(begin_date, end_date)
    end

    def find_openings(begin_date, end_date)
      @openings = []
      checkin_date = Date.parse(begin_date)
      checkout_date = Date.parse(end_date)
      listings.each do |listing|
        @openings << listing unless listing.reservations.any? do |reservation|
          checkin_date.between?(reservation.checkin, reservation.checkout) && checkout_date.between?(reservation.checkin, reservation.checkout)
        end
      end
      @openings
    end
  end

  module ClassMethods
    def highest_ratio_res_to_listings
      @ratio = {"" => 0}
      self.all.each do |loc|
        if loc.listings.count != 0 && loc.reservations.count != 0
          @listings = loc.listings.count
          @reservations = loc.reservations.count
          ratio = @reservations/@listings
          @ratio = {loc => ratio} if ratio > (@ratio.values[0] || 0)
        end
      end
      @ratio.keys[0]
    end

    def most_res
      @most_res = {"" => 0}
      self.all.each do |loc|
        @total = loc.reservations.count
        @most_res = {loc => @total } if @total > @most_res.values[0]
      end
      @most_res.keys[0]
    end
  end
end
