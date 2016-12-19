class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods



  def self.highest_ratio_res_to_listings
    self.all.max_by do |city| # Do city.all and then sorty by highest
      city.listings.collect {|listing| listing.reservations.count}.sum #then for each city object, get the listings and then collect the total number of reservations for each listing
      #after this it will be sorted by highest to lowest, returning the object with the highest ratio of reservations per listing.
    end

  end

  def self.most_res
   self.all.max_by do |city|
     city.listings.map {|listing| listing.reservations.count}.sum
   end
 end

 def city_openings(guest_checkin, guest_checkout)
   self.listings.each do |listing|
     listing.reservations.collect do |r|
       if r.checkin <= guest_checkout.to_date && r.checkout >= guest_checkout.to_date
         listing
       end
     end
   end
 end

end
