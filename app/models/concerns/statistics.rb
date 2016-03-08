module Statistics
  extend ActiveSupport::Concern


module ClassMethods
    def highest_ratio_res_to_listings
      #all_reservations_by_listing_id = Reservation.group(:listing_id).count
      #binding.pry
      listing_count={}
      self.all.each do |place|
      if place.reservations.count == 0
          ratio = 0
        else
          ratio = place.reservations.count/place.listings.count
        end
        listing_count.store(place, ratio)
      end
      highest_ratio_place = listing_count.select{|k,v| v == listing_count.values.max }
      highest_ratio_place.first.first
      # all_reservations_by_listing_id = self.reservations.count
      # #checks the details of listings for the reservations
      # neighborhood_count={}
      # all_reservations_by_listing_id.each {|key, value|
      #   the_neighborhood = Neighborhood.find(Listing.find(key).neighborhood_id)
      #   neighborhood_count.has_key?(the_neighborhood) ?  neighborhood_count[the_neighborhood]=neighborhood_count[the_neighborhood]+(value/the_neighborhood.listings.count.to_f) : neighborhood_count[the_neighborhood]=(value/the_neighborhood.listings.count.to_f)
      # }
      # max_listings_neighborhood = neighborhood_count.select {|k,v| v == neighborhood_count.values.max } # gets the max valued hash-key pair
      # max_listings_neighborhood.keys[0] # since the city is stored as key return the key for the max value
    end

    def most_res
      place_with_most_res = nil
      max_res_count = 0
      self.all.each do |place|
        if place.reservations.count > max_res_count
          max_res_count = place.reservations.count
          place_with_most_res = place
        else
          next
        end
      end
      place_with_most_res
    end
end
end
