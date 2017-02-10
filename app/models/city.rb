class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    openings = []
    Listing.all.each do |l|
      conflicts = []
      l.reservations.each do |r|
        if r.checkout < start_date.to_date || r.checkin > end_date.to_date
        else
          conflicts << r
          # The above cannot be the most efficient approach, since, as soon as we find one conflict, we should give up on the listing
        end
      end
      # The line below runs after all the reservations from a given listing have been analyzed.
      if conflicts == []
        openings << l
      end
      # When this line is reached, a given listing has been fully analyzed.
    end
    # At this point, all listings have been analyzed. Let's return the ones without conflicts.
    openings
  end

  def self.highest_ratio_res_to_listings
    winner = nil
    winning_ratio = 0
    City.all.each do |c|
      reservations = 0
      listings = 0
      c.listings.each do |l|
        listings += 1
        l.reservations.each do |r|
          reservations += 1
        end # Close reservation loop
      end # Close listing loop
      contestant_ratio = reservations / listings
      if contestant_ratio > winning_ratio
        winner = c
        winning_ratio = contestant_ratio
      end # Close leaderboard testing
    end # Close city loop
    winner
  end # Close method

end
