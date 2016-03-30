module Openings

  module ForInstance
    def find_openings(start_date, end_date)
      openings = self.listings.select do |listing|
        listing.reservations.all? do |res|
          !res.checkin.between?(start_date, end_date) && !res.checkout.between?(start_date, end_date)
        end
      end
    end
  end

  module ForClass
    def highest_ratio_res_to_listings
      #go through each ONE (city/neighborhood)...
      self.all.max_by do |one|
        num_of_res = 0
        #...add up num_of_listings
        num_of_list = one.listings.size
        #...and through each ONE's listings...
        one.listings.each do |listing|
          #...and add up all that listings' reservations
          num_of_res += listing.reservations.size
        end

        #then calculate the ratio
        if num_of_list == 0
          0
        else
          ratio = num_of_res.fdiv(num_of_list)
        end
      end
    end

    def most_res
      #find maximum ONE (city/neighborhood)
      self.all.max_by do |one|
        num_of_res = 0
        one.listings.each do |listing|
          #sum each of that ONE's listings' reservations
          num_of_res += listing.reservations.size
        end
        #this has to be here in order for 'max_by' to work.
        #otherwise it goes by 'each's return value
        num_of_res
      end
    end
  end

end
