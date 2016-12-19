class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings



  def self.highest_ratio_res_to_listings
    self.all.max_by do |neighborhood| # Do city.all and then sorty by highest
      neighborhood.listings.collect {|listing| listing.reservations.count}.sum #then for each city object, get the listings and then collect the total number of reservations for each listing
      #after this it will be sorted by highest to lowest, returning the object with the highest ratio of reservations per listing.
    end

  end

  def self.most_res
   self.all.max_by do |city|
     city.listings.map {|listing| listing.reservations.count}.sum
   end
 end
 def neighborhood_openings(date1, date2)
   self.listings.each do |listing|
     listing.reservations.collect do |r|
       if r.checkin <= date2.to_date && r.checkout >= date1.to_date
         listing
       end
     end
   end
 end

  def availability

    #reservation where the listing id doesn't have a reservation id, in other words so it is open.
    #collect the list and iterate over it to see if any of the dates match the booked dates.
  end


end
