class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(startdate, enddate)
    self.listings.where(startdate, enddate)
  end


  # City class methods .highest_ratio_res_to_listings knows the city with the highest ratio of reservations to listings
  #    Failure/Error: expect(City.highest_ratio_res_to_listings).to eq(City.find_by(:name => "NYC"))
     
  #      expected: #<City id: 1, name: "NYC", created_at: "2016-10-13 23:26:28", updated_at: "2016-10-13 23:26:28">
  #           got: nil

  # seems like we need to check a citys listings total reservations and add up the total reserations of each city 
  # from there we compare each citys  total rsvp count, if one is higher, we take that one instead


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

 