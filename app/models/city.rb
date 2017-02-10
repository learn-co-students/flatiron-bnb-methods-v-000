class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  extend Measurable::ClassMethods

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

  def self.most_res
    winner = nil
    winning_count = 0
    City.all.each do |c|
      count = 0
      c.listings.each do |l|
        l.reservations.each do |r|
          count += 1
        end # Close reservation loop
      end # Close listing loop
      if count > winning_count
        winner = c
        winning_count = count
      end # Close leaderboard testing
    end # Close city loop
    winner
  end # Close method

end
