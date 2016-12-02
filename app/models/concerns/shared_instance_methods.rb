module SharedInstanceMethods
  def find_ratio_res_to_listings
    total_res = self.listings.map do |listing|
      listing.reservations.count
    end.sum

    if self.listings.count != 0
      the_ratio = total_res / self.listings.count
    else 
      the_ratio = 0
    end
    the_ratio
  end

  def city_or_neighborhood_reservations
    if self.class == City
      number = self.neighborhoods.map do |n|
        n.listings.map do |l|
          l.reservations.count
        end
      end.flatten.sum
    else
      number = self.listings.map do |l|
        l.reservations.count
      end.flatten.sum
    end
    number
  end

end