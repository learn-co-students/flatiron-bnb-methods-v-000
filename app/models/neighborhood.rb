class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


  def neighborhood_openings(startdate, enddate)
    self.listings.where(startdate, enddate)
  end


  def self.highest_ratio_res_to_listings
    key_nabe = nil 
    key_rsvp_count = 0 
    @cities = City.all 

    @cities.each do |city|
      city.neighborhoods.each do |nhood| 
        rsvp_count = 0
        nhood.listings.each do |listing|
        rsvp_count += listing.reservations.count
     end # do - listing
     
       if key_rsvp_count == 0 || rsvp_count > key_rsvp_count
        key_nabe = nhood
        key_rsvp_count = rsvp_count
       end # if 

     end # do - nhood
   end # do - city
   key_nabe
  end

   def self.most_res
    key_nabe = nil 
    key_rsvp_count = 0 
    @cities = City.all 

    @cities.each do |city|
      city.neighborhoods.each do |nhood| 
        rsvp_count = 0
        nhood.listings.each do |listing|
        rsvp_count += listing.reservations.count
     end # do - listing
     
       if key_rsvp_count == 0 || rsvp_count > key_rsvp_count
        key_nabe = nhood
        key_rsvp_count = rsvp_count
       end # if 

     end # do - nhood
   end # do - city
   key_nabe
  end

end
