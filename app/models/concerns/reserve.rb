module Reserve
  extend ActiveSupport::Concern

    def openings(start_date, end_date)
      self.listings.select do |listing|
        listing.reservations.none? do |r|
          ( (r.checkin...r.checkout).cover?(start_date) || (start_date...end_date).cover?(r.checkin) ) && r.status == 'accepted'
        end
      end
    end


    def res_list_ratio
      if self.listings.count > 0
        self.reservations.count.to_f / self.listings.count.to_f
      else
        0
      end
    end

  class_methods do

    def highest_ratio_res_to_listings
      self.all.max do |a, b|
         a.res_list_ratio <=> b.res_list_ratio
      end
    end

    def most_res
      self.all.max do |a, b|
        a.reservations.count <=> b.reservations.count
      end
    end

  end
end
