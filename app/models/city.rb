class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin_date, checkout_date)
    Listing.available(checkin_date,checkout_date).uniq & self.listings
  end

#should return listing 2, 3
   
   #where.not where.not(reservations: {checkin: checkin_date..checkout_date}
   # joins(:reservations)
   #Listing.joins(:reservations, :city).where.not(reservations:{checkin: checkin_date..checkout_date})

  # binding.pry
 #  reservations_array = []

  #  self.listings.each do |listing|
   #  reservations_array << listing.reservations
  #    end
    
   
   #   listings_array = []
#     i = 0
 #      until reservations_array[i] == nil
  #      reservations_array[i].each do |reservation|
   #       if !(checkin_date.to_date..checkout_date.to_date).overlaps?(reservation.checkin..reservation.checkout)
    #        listings_array << reservation.listing 
     #     end
  #      end
   #     i += 1
    #  end
  #  listings_array = listings_array.uniq
   # listings_array

  #  end

    #reservations.find_all{|x| if (checkin_date - x.checkin_date)}



    #city - neighborhood - listings - reservations
    #reservations checks the dates inputted
    #city.listings[0].reservations - will give all the reservations from that first listing.
    #city.listings.each etc 

    #city.listings.each do |listing|
     # listing.reservations.find_all {|x| x.checkin > checkout_date}
#  end

  #def self.most_res
  #  city.listings.find_all{ |x| maximum(x.reservations.count_}

 # array =[]    
 # city.listings.each do |x|
  #  array << x.reservations.count
  #  array.sum

 # end

end



#(start date - other end date) * ( other start date - end date ) >= 0 
# this will tell if dates overlap. 