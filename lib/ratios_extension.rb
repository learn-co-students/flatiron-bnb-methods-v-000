module RatiosExtension

    def self.most_res
      self.all 
      # need to see which neighborhood has most reservations


      # self.listings.each do |listing|
      #   listing.reservations.collect {|reservation| reservation.status != "pending"}
      # end.
      # x.group_by{|a| a }.sort_by{|a,b| b.size<=>a.size}.first[0]
    end

    def self.highest_ratio_res_to_listings
      binding.pry
    end

    def self.neighborhood_openings(date1, date2)

    end

end