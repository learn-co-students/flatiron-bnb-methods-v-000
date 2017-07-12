class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
    self.listings.select{ |listing| listing.available?(start_date, end_date) }
  end


  # def self.highest_ratio_res_to_listings
  #   self.all.max_by{ |city| city.ratio_reservations_to_listings }
  # end

  # def ratio_reservations_to_listings
  #   listings_count = self.listings.count
  #   reservations_count = self.listings.map{ |listing| listing.reservations.count}.reduce(:+)
  #   reservations_count / listings_count
  # end

  def self.highest_ratio_res_to_listings
    # SELECT cities.name, COUNT(listings.id), COUNT(reservations.id), cast(COUNT(reservations.id) as float)/cast(COUNT(listings.id) as float) as ratio FROM cities JOIN neighborhoods ON cities.id = neighborhoods.city_id LEFT JOIN listings ON neighborhoods.id = listings.neighborhood_id LEFT JOIN reservations ON listings.id = reservations.listing_id 
    # SELECT COUNT(DISTINCT listings.id), * FROM "cities" LEFT JOIN "neighborhoods" ON "neighborhoods"."city_id" = "cities"."id" LEFT JOIN "neighborhoods" "neighborhoods_cities_join" ON "neighborhoods_cities_join"."city_id" = "cities"."id" LEFT JOIN "listings" ON "listings"."neighborhood_id" = "neighborhoods_cities_join"."id" GROUP BY cities.name
    
    # City Load (0.6ms)  
    # SELECT cities.id, cities.name, COUNT(DISTINCT listings.id) as listing_count, COUNT(DISTINCT reservations.id) as reservation_count, cast(COUNT(DISTINCT reservations.id) as float)/cast(COUNT(DISTINCT listings.id) as float) as ratio 
    # FROM "cities" INNER JOIN "neighborhoods" ON "neighborhoods"."city_id" = "cities"."id" 
    # INNER JOIN "neighborhoods" "neighborhoods_cities_join" ON "neighborhoods_cities_join"."city_id" = "cities"."id" 
    # INNER JOIN "listings" ON "listings"."neighborhood_id" = "neighborhoods_cities_join"."id" 
    # INNER JOIN "neighborhoods" "neighborhoods_cities_join_2" ON "neighborhoods_cities_join_2"."city_id" = "cities"."id" 
    # INNER JOIN "listings" "listings_cities_join" ON "listings_cities_join"."neighborhood_id" = "neighborhoods_cities_join_2"."id" 
    # INNER JOIN "reservations" ON "reservations"."listing_id" = "listings_cities_join"."id" 
    # GROUP BY cities.id  ORDER BY ratio DESC

    id = self.select("cities.id, cities.name, COUNT(DISTINCT listings.id) as listing_count, COUNT(DISTINCT reservations.id) as reservation_count, cast(COUNT(DISTINCT reservations.id) as float)/cast(COUNT(DISTINCT listings.id) as float) as ratio").joins(:neighborhoods).joins(:listings).joins(:reservations).group("cities.id").order("ratio DESC").first.id
    self.find(id)
  end

  def self.most_res
    id = self.select("cities.id, COUNT(DISTINCT reservations.id) as res_count").joins(:neighborhoods).joins(:listings).joins(:reservations).group("cities.id").order("res_count DESC").first.id
    self.find(id)
  end

end

