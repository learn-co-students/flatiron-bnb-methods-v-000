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

 def city_openings(start_date, end_date)
    booked_listings = "select distinct(l.id) FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id JOIN reservations r on l.id = r.listing_id WHERE r.checkin >= #{start_date} AND r.checkout <= #{end_date}"
    Listing.find_by_sql("select l.id, l.title FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id WHERE l.id NOT IN (#{booked_listings})")
  end
end
