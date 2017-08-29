module ListingStats

  module ClassMethods

    def highest_ratio_res_to_listings
      sorted = self.all.sort_by do |location|
        res_count = location.listings.reservation_count.to_f
        list_count = location.listings.count
        list_count > 0 ? res_count/list_count : 0
      end
      sorted[-1]
    end
  
    def most_res
      self.all.sort {|location1, location2| location1.listings.reservation_count <=> location2.listings.reservation_count}[-1]
    end

  end

  module InstanceMethods
    
    def find_openings(range_begin, range_end)
      listings.where.not(id: listings.joins(:reservations).where(reservations_arel[:checkout].gteq(range_begin).and(reservations_arel[:checkout].lteq(range_end)).or(reservations_arel[:checkin].gteq(range_begin).and(reservations_arel[:checkin].lteq(range_end))).or(reservations_arel[:checkin].lteq(range_begin).and(reservations_arel[:checkout].gteq(range_end)))).group('listings.id').pluck(:id))
    end

  end
  
end