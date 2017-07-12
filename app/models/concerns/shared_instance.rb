module SharedInstance

  def openings(starting, ending)
    results = []
    start_date = Date.parse(starting)
    end_date = Date.parse(ending)
    self.listings.each do |listing|
      valid = true
      listing.reservations.each do |reservation|
        if !(reservation.checkin > end_date || reservation.checkout < start_date)
          valid = false
        end
      end
      if valid
        results << listing
      end
    end
    results
  end

end
