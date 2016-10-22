module Shareable

  def openings(start_date, end_date)
    available_reservations = []
    listings.each do |listing|
      available = listing.reservations.all? do |res|
        Date.parse(start_date) >= res.checkout || Date.parse(end_date) <= res.checkin
      end
      if available 
        available_reservations << listing
      end 
    end
    available_reservations
  end  

  module Shareable::ClassMethods
    def highest_ratio_res_to_listings
      self.all.max_by do |area|
        res = area.reservations.count 
        area_listings = area.listings.count 
        res.to_f/area_listings
      end 
    end 

    def most_res
      self.all.max_by do |area|
        area.reservations.count
      end 
    end 

  end 

end 
