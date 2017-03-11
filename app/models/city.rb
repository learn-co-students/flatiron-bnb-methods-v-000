class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)

    self.listings.merge(Listing.available(start_date, end_date))
    # self.listings.select{ |listing| listing.available(start_date, end_date) }
























    # Listing.joins(:neighborhood).joins("LEFT OUTER JOIN reservations ON listings.id = reservations.listing_id").where(neighborhoods: {city_id: self.id}, reservations: {id: nil})+Listing.joins(:neighborhood).joins(:reservations).where("neighborhoods.city_id = ?", self.id).where.not("reservations.checkout >= ? AND ? >= reservations.checkin", start_date, end_date)

    # Listing.joins(:neighborhood).joins("LEFT OUTER JOIN reservations ON listings.id = reservations.listing_id").where(neighborhoods: {city_id: 1}, reservations: {id: nil})+Listing.joins(:neighborhood).joins(:reservations).where("neighborhoods.city_id = ? AND NOT ? BETWEEN reservations.checkin AND reservations.checkout AND NOT ? BETWEEN reservations.checkin AND reservations.checkout", 1, '2014-05-01', '2014-05-05').group("listings.id")

  	# self.listings.merge( Listing.bookable(start_date, end_date) )
  	# intersect the city's (neighborhood's) listings with bookable listings
  	# City.first.city_openings('2014-05-01', '2014-05-05')
  	# will SQL query
  	#
  	# v1
  	# SELECT "listings".* FROM "listings" 
  	# 	INNER JOIN "reservations" ON "reservations"."listing_id" = "listings"."id" 
  	# 	INNER JOIN "neighborhoods" ON "listings"."neighborhood_id" = "neighborhoods"."id" 
  	# 	WHERE "neighborhoods"."city_id" = ? 
  	# 	AND (NOT (checkin <= '2014-05-05' AND checkout >= '2014-05-01'))
  	#   [["city_id", 1]]
  	#
  	# v2
  	# SELECT "listings".* FROM "listings" 
  	# 	INNER JOIN "reservations" ON "reservations"."listing_id" = "listings"."id" 
  	# 	INNER JOIN "neighborhoods" ON "listings"."neighborhood_id" = "neighborhoods"."id" 
  	# 	WHERE "neighborhoods"."city_id" = ? 
  	# 	AND (NOT ("reservations"."checkin" BETWEEN '2014-05-01' AND '2014-05-05')) 
  	# 	AND (NOT ("reservations"."checkout" BETWEEN '2014-05-01' AND '2014-05-05'))  
  	# 	[["city_id", 1]]
  	#
  	# v3
  	# SELECT "listings".* FROM "listings" 
  	# 	INNER JOIN "reservations" ON "reservations"."listing_id" = "listings"."id" 
  	# 	WHERE (NOT ("reservations"."checkin" BETWEEN '2014-05-01' AND '2014-05-05'))
  	# SELECT "listings".* FROM "listings" 
  	# 	INNER JOIN "reservations" ON "reservations"."listing_id" = "listings"."id" 
  	# 	WHERE (NOT ("reservations"."checkout" BETWEEN '2014-05-01' AND '2014-05-05'))
  	# SELECT "listings".* FROM "listings" 
  	# 	INNER JOIN "neighborhoods" ON "listings"."neighborhood_id" = "neighborhoods"."id" 
  	# 	WHERE "neighborhoods"."city_id" = ?  
  	# 	[["city_id", 1]]		
  end
end

