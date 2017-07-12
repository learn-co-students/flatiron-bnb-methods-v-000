class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


  def neighborhood_openings(checkin_date, checkout_date)
    
    start_date = DateTime.strptime(checkin_date, "%Y-%m-%d")
    end_date =  DateTime.strptime(checkout_date, "%Y-%m-%d")
    
    search_range = (start_date..end_date)
    neighborhoods = []

    self.listings.each do |each_listing|
      # binding.pry
      checkins = []
      checkouts = []
        each_listing.reservations.each do |each_reservation|
          checkins << each_reservation.checkin
          checkouts << each_reservation.checkout
        end
           neighborhoods << each_listing if !search_range.overlaps?(checkins.sort.first .. checkouts.sort.last)            
    end
      neighborhoods
  end

  def self.highest_ratio_res_to_listings
    ratio = 0.0
    highest_ratio = nil
      Neighborhood.all.each do |neighborhood|
        if ratio < neighborhood.reservation_count/neighborhood.listings.count.to_f   
          ratio = neighborhood.reservation_count/neighborhood.listings.count.to_f   
          highest_ratio = neighborhood
        end      
      end 
    highest_ratio 
  end

  def reservation_count  
    count_reservations = 0    
    self.listings.each do |listing|
      count_reservations += listing.reservations.count  
    end
      count_reservations
  end

  def self.most_res
    
    reservation = 0  
    highest_reservation = nil
    
    Neighborhood.all.each do |neighborhood|
      
      neighborhood.listings.each do |listing| 
          res_count = listing.reservations.count  
            if reservation < res_count
              reservation += res_count 
              highest_reservation = neighborhood
        end
      end
    end
    highest_reservation
  end



  
end
