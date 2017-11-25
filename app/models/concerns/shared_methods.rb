module SharedMethods
  def openings(date1, date2)
    # #reject returns a new array containing the items in self for which the block is not true
    self.listings.reject do |listing| 
      listing.reservations.any? do |reservation| 
        reservation.checkin.to_s.between?(date1, date2)
      end
    end
  end

  def h_ratio_res_to_listings
    most_full_area = nil
    listing_reservations = 0

    self.all.each do |area|
      area.listings.each do |listing|
        if listing_reservations < listing.reservations.count
          listing_reservations = listing.reservations.count
          most_full_area = area
        end
      end
    end
    most_full_area
  end
end
