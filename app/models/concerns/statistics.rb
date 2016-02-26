module Statistics
  extend ActiveSupport::Concern
  module ClassMethods 

    def highest_ratio_res_to_listings
        self.all.max_by do |x| 
          x.listings.map do |l| 
            if x.listings.count == 0
              0
            else
              l.reservations.flatten.count / x.listings.count
            end
          end
        end
    end

    def most_res
        self.all.max_by { |x| x.listings.map { |l| l.reservations }.flatten.count}
    end
  end

  def openings(*date)
    openings = []
    date.each do |d|
      d = Date.parse(d) unless d.class == Date
      self.listings.each do |l|
        openings << l if l.reservations.none? { |r| r.checkin <= d && r.checkout >= d }
      end
    end
    openings
  end
end
