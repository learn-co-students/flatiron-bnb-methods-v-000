module Concerns::Popular 
  def highest_ratio_res_to_listings
    most_full_place = "No listings in this program" 
    last_place_reservation_ratio = 0
    self.all.each do |place| 
      place_reservation_count = 0
      place.listings.each do |listing|
        place_reservation_count += listing.reservations.count
      end
      if place.listings.count > 0
        place_reservation_ratio = place_reservation_count / place.listings.count 
        if place_reservation_ratio > last_place_reservation_ratio
          last_place_reservation_ratio = place_reservation_ratio
          most_full_place = place
        end
      end
    end
    most_full_place
  end
  
  def most_res
    most_reserved_place = "No listings in the program"
    last_place_count = 0
    self.all.each do |place|  
      place_count = 0 
      place.listings.each do |listing|
        place_count += listing.reservations.count
      end
      if place_count > last_place_count
        last_place_count = place_count 
        most_reserved_place = place
      end
    end
    most_reserved_place
  end
end