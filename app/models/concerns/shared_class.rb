module SharedClass
  extend ActiveSupport::Concern

  def highest_ratio_res_to_listings
    high = 0
    return_object = nil
    self.all.each do |object|
      listings = object.listings.count
      reservations = 0
      object.listings.all.each do |listing|
        reservations += listing.reservations.count
      end
      if listings > 0
        ratio = reservations / listings
        if ratio > high
          return_object = object
          high = ratio
        end
      end
    end
    return_object
  end

  def most_res
    high = 0
    return_object = nil
    self.all.each do |object|
      reservations = 0
      object.listings.all.each do |listing|
        reservations += listing.reservations.count
      end
      #binding.pry
      if reservations >= high
        return_object = object
        high = reservations
      end
    end
    return_object
  end

end
