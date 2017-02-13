class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  #city_openings method should return all of the Listing objects that are
  #available for the entire span that is inputted.

  def city_openings(start_date, end_date)
    #listing.reservations narrow down reservations 
  end


end

#   reservations.each do |r|
#     if r.listing.vacant?(start_date, end_date)
#       r.listing
#     end
#   end
