
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


    def city_openings(checkin_date, checkout_date)

      start_date = DateTime.strptime(checkin_date, "%Y-%m-%d")
      end_date =  DateTime.strptime(checkout_date, "%Y-%m-%d")
      
      search_range = (start_date..end_date)
      cities = []

      self.listings.each do |each_listing|
        checkins = []
        checkouts = []
          each_listing.reservations.each do |each_reservation|
            checkins << each_reservation.checkin
            checkouts << each_reservation.checkout
          end
             cities << each_listing if !search_range.overlaps?(checkins.sort.first .. checkouts.sort.last)            
      end
        cities
    end

    def self.highest_ratio_res_to_listings
      ratio = 0.0
      highest_ratio = nil
        City.all.each do |city|
          if ratio < city.reservation_count/city.listings.count.to_f   
            ratio = city.reservation_count/city.listings.count.to_f   
            highest_ratio = city
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
      
      City.all.each do |city|
        
        city.listings.each do |listing| 
            res_count = listing.reservations.count  
              if reservation < res_count
                reservation += res_count 
                highest_reservation = city
          end
        end
      end
      highest_reservation
    end


end
