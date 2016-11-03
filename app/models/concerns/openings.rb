module Openings
  def open_listings(begin_date, end_date)
    listings.collect do |listing|
      if !overlaps?(Date.parse(begin_date), Date.parse(end_date), listing)
        listing
      else
        nil
      end
    end
  end

  def available?(begin_date, end_date)
      !overlaps?(begin_date, end_date, self)
  end

  def overlaps?(begin_date, end_date, listing)
    overlaps = false
    if begin_date && end_date
      listing.reservations.each do |reservation|
        if (begin_date - reservation.checkout) * (reservation.checkin - end_date) >= 0
          overlaps = true
        end
      end
    end
    overlaps
  end
end
