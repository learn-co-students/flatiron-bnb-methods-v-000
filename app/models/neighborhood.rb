require 'pry'
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


 def neighborhood_openings(start_date, end_date)
   openings = []
     self.listings.collect do |listing|
       listing.reservations.collect do |res|
         if res.checkin <= end_date.to_date || res.checkout >= start_date.to_date
           openings << listing
         end
       end
     end
     openings
  end


end
