class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(startdate, enddate)
    self.listings.where(startdate, enddate)
  end


  def self.highest_ratio_res_to_listings
    key_city = nil 
    key_rsvp_count = 0 
    @cities = City.all 

    @cities.each do |city|
      rsvp_count = 0 
      city.listings.each do |listing|
      rsvp_count += listing.reservations.count
     end # do 
     
       if key_rsvp_count == 0 || rsvp_count > key_rsvp_count
        key_city = city 
        key_rsvp_count = rsvp_count
       end # if 
     end # do 
   key_city
  end

  def self.most_res
    key_city = nil 
    key_rsvp_count = 0 
    @cities = City.all 

    @cities.each do |city|
      rsvp_count = 0 
      city.listings.each do |listing|
      rsvp_count += listing.reservations.count
     end # do 
     
       if key_rsvp_count == 0 || rsvp_count > key_rsvp_count
        key_city = city 
        key_rsvp_count = rsvp_count
       end # if 
     end # do 
   key_city
   end # def 



end

 