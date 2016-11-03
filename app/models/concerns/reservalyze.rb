module Reservalyze
  def highest_ratio_res_to_listings
    best_ratio = 0
    best = nil
    all.each do |x|
      num_of_reservations = 0
      x.listings.each do |listing|
        listing.reservations.each do |reservation|
          num_of_reservations += 1
        end
      end
      if x.listings.size > 0 && best_ratio < num_of_reservations / x.listings.size
        best_ratio = num_of_reservations / x.listings.size
        best = x
      end
    end
    best
  end

  def most_res
    winner = nil
    most_reservations = 0
    all.each do |x|
      num_of_reservations = 0
      x.listings.each do |listing|
        num_of_reservations += listing.reservations.count
      end
      if most_reservations < num_of_reservations
        most_reservations = num_of_reservations
        winner = x
      end
    end
    winner
  end
end
