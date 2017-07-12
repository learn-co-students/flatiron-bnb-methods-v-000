module StatusMethods
  # module InstanceMethods
  #   #return all Listing objects available for the entire span that is inputted
  #     def city_openings(checkin, checkout)
  #   requested_dates = ((Date.parse(checkin))..(Date.parse(checkout))).collect {|day| day}
  #   self.listings.select do |listing|
  #     if listing.dates_occupied
  #       requested_dates.none?{|date| listing.dates_occupied.include?(date)}
  #     else
  #       listing
  #     end
  #   end
  # end
  #
  # end

  module ClassMethods
    #returns the city with the highest amount of reservations per listing
      def highest_ratio_res_to_listings
        self.all.max_by do |location|
          if location.listings.count > 0 && location.reservations.count > 0
            location.reservations.count.to_f/location.listings.count.to_f
          else
            0
          end
        end
      end

      #returns city/neighborhood with the most total number of reservations
      def most_res
#        binding.pry
        self.all.max do |a, b|
          a.reservations.count <=> b.reservations.count
        end
      end

  end

end
