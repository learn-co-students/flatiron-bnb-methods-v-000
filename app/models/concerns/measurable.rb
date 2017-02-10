module Measurable
  module ClassMethods
    def highest_ratio_res_to_listings
      winner = nil
      winning_ratio = 0
      self.all.each do |geo| # It is anticipated that the geo types that will extend this class method are: City, Neighborhood.
        reservations = 0
        listings = 0
        geo.listings.each do |l|
          listings += 1
          l.reservations.each do |r|
            reservations += 1
          end # Close reservation loop
        end # Close listing loop
        if listings > 0
          contestant_ratio = reservations / listings
          if contestant_ratio > winning_ratio
            winner = geo
            winning_ratio = contestant_ratio
          end
        end
      end # Close geo loop
      winner
    end # Close method

    def most_res
      winner = nil
      winning_count = 0
      self.all.each do |geo|
        count = 0
        geo.listings.each do |l|
          l.reservations.each do |r|
            count += 1
          end # Close reservation loop
        end # Close listing loop
        if count > winning_count
          winner = geo
          winning_count = count
        end # Close leaderboard testing
      end # Close geo loop
      winner
    end # Close method

  end # Close ClassMethods

  module InstanceMethods
  end
end
