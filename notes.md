SELECT listings.id AS listing_id, listings.address AS listing_address, neighborhoods.name AS neighborhood_name, neighborhoods.city_id, reservations.*
FROM listings
INNER JOIN neighborhoods ON listings.neighborhood_id = neighborhoods.id
WHERE neighborhoods.city_id = 1
INNER JOIN reservations ON listings.id = reservations.listing_id


SELECT listings.id AS listing_id, listings.address AS listing_address, reservations.*
FROM listings
INNER JOIN reservations ON listings.id = reservations.listing_id


SELECT listings.id AS listing_id, listings.address AS listing_address, neighborhoods.name AS neighborhood_name, neighborhoods.city_id, reservations.*
FROM listings
INNER JOIN neighborhoods ON listings.neighborhood_id = neighborhoods.id
INNER JOIN reservations ON listings.id = reservations.listing_id
WHERE neighborhoods.city_id = 1

-----

SELECT listings.id AS listing_id, listings.address AS listing_address, neighborhoods.name AS neighborhood_name, neighborhoods.city_id, reservations.id AS res_id, reservations.checkin, reservations.checkout
FROM listings
INNER JOIN neighborhoods ON listings.neighborhood_id = neighborhoods.id
LEFT OUTER JOIN reservations ON listings.id = reservations.listing_id
WHERE neighborhoods.city_id = 1 
AND
NOT "2014-05-01" BETWEEN reservations.checkin AND reservations.checkout
AND
NOT "2014-05-05" BETWEEN reservations.checkin AND reservations.checkout
ORDER BY reservations.checkout DESC

=> This one works!

----


SELECT listings.*, reservations.*
FROM listings
INNER JOIN neighborhoods ON listings.neighborhood_id = neighborhoods.id
LEFT OUTER JOIN reservations ON listings.id = reservations.listing_id
WHERE neighborhoods.city_id = 1
UNION
SELECT listings.*, reservations.*
FROM listings
INNER JOIN neighborhoods ON listings.neighborhood_id = neighborhoods.id
INNER JOIN reservations ON listings.id = reservations.listing_id
WHERE neighborhoods.city_id = 1
AND
NOT "2014-05-01" BETWEEN reservations.checkin AND reservations.checkout
AND
NOT "2014-05-05" BETWEEN reservations.checkin AND reservations.checkout
GROUP BY listings.id


=> this one works and UNIONS, then groups

------

SELECT listings.*, reservations.*
FROM listings
INNER JOIN neighborhoods ON listings.neighborhood_id = neighborhoods.id
LEFT OUTER JOIN reservations ON listings.id = reservations.listing_id
WHERE neighborhoods.city_id = 1
AND reservations.id IS NULL

UNION

SELECT listings.*, reservations.*
FROM listings
INNER JOIN neighborhoods ON listings.neighborhood_id = neighborhoods.id
INNER JOIN reservations ON listings.id = reservations.listing_id
WHERE neighborhoods.city_id = 1
AND
NOT "2014-05-01" BETWEEN reservations.checkin AND reservations.checkout
AND
NOT "2014-05-05" BETWEEN reservations.checkin AND reservations.checkout

GROUP BY listings.id


=> final one ?


-------

    query = "SELECT listings.*, reservations.*
                    FROM listings
                    INNER JOIN neighborhoods ON listings.neighborhood_id = neighborhoods.id
                    LEFT OUTER JOIN reservations ON listings.id = reservations.listing_id
                    WHERE neighborhoods.city_id = 1
                    AND reservations.id IS NULL
                    UNION
                    SELECT listings.*, reservations.*
                    FROM listings
                    INNER JOIN neighborhoods ON listings.neighborhood_id = neighborhoods.id
                    INNER JOIN reservations ON listings.id = reservations.listing_id
                    WHERE neighborhoods.city_id = ?
                    AND
                    NOT ? BETWEEN reservations.checkin AND reservations.checkout
                    AND
                    NOT ? BETWEEN reservations.checkin AND reservations.checkout
                    GROUP BY listings.id"
    self.class.execute_sql(query, {self.id, start_date, end_date})


--------
        city_listings = []
    Listing.joins(:neighborhoods).where(neighborhoods: {city_id: self.id} ).each




 ----
 

 SELECT listings.*
	FROM listings
	INNER JOIN neighborhoods ON listings.neighborhood_id = neighborhoods.id
	LEFT OUTER JOIN reservations ON listings.id = reservations.listing_id
	WHERE neighborhoods.city_id = 1
	AND reservations.id IS NULL

	UNION

	SELECT listings.*
	FROM listings
	INNER JOIN neighborhoods ON listings.neighborhood_id = neighborhoods.id
	INNER JOIN reservations ON listings.id = reservations.listing_id
	WHERE neighborhoods.city_id = 1
	AND
	NOT "2014-05-01" BETWEEN reservations.checkin AND reservations.checkout
	AND
	NOT "2014-05-05" BETWEEN reservations.checkin AND reservations.checkout

	GROUP BY listings.id   


-------


First part of the query

#<ActiveRecord::Relation [

#<Listing id: 1, address: "123 Main Street", listing_type: "private room", title: "Beautiful Apartment on Main Street", description: "My apartment is great. there's a bedroom. close to...", price: #<BigDecimal:7fcb1a59d548,'0.5E2',9(27)>, neighborhood_id: 1, host_id: 1, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 

#<Listing id: 1, address: "123 Main Street", listing_type: "private room", title: "Beautiful Apartment on Main Street", description: "My apartment is great. there's a bedroom. close to...", price: #<BigDecimal:7fcb1c40bc28,'0.5E2',9(27)>, neighborhood_id: 1, host_id: 1, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 

#<Listing id: 1, address: "123 Main Street", listing_type: "private room", title: "Beautiful Apartment on Main Street", description: "My apartment is great. there's a bedroom. close to...", price: #<BigDecimal:7fcb1c409ea0,'0.5E2',9(27)>, neighborhood_id: 1, host_id: 1, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 


#<Listing id: 2, address: "6 Maple Street", listing_type: "shared room", title: "Shared room in apartment", description: "shared a room with me because I'm poor", price: #<BigDecimal:7fcb1c408b90,'0.15E2',9(27)>, neighborhood_id: 2, host_id: 2, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 


#<Listing id: 3, address: "44 Ridge Lane", listing_type: "whole house", title: "Beautiful Home on Mountain", description: "Whole house for rent on mountain. Many bedrooms.", price: #<BigDecimal:7fcb1c403550,'0.2E3',9(27)>, neighborhood_id: 3, host_id: 3, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 


#<Listing id: 4, address: "4782 Yaya Lane", listing_type: "private room", title: "Beautiful Room in awesome house", description: "Art collective hosue.", price: #<BigDecimal:7fcb1c4017c8,'0.4E3',9(27)>, neighborhood_id: 4, host_id: 3, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 

#<Listing id: 4, address: "4782 Yaya Lane", listing_type: "private room", title: "Beautiful Room in awesome house", description: "Art collective hosue.", price: #<BigDecimal:7fcb1a597f58,'0.4E3',9(27)>, neighborhood_id: 4, host_id: 3, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">]>


-------

Complete query

[#<Listing id: 3, address: "44 Ridge Lane", listing_type: "whole house", title: "Beautiful Home on Mountain", description: "Whole house for rent on mountain. Many bedrooms.", price: #<BigDecimal:7fcb1a4e70e0,'0.2E3',9(27)>, neighborhood_id: 3, host_id: 3, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 


##### UNION


#<Listing id: 1, address: "123 Main Street", listing_type: "private room", title: "Beautiful Apartment on Main Street", description: "My apartment is great. there's a bedroom. close to...", price: #<BigDecimal:7fcb1a4e49a8,'0.5E2',9(27)>, neighborhood_id: 1, host_id: 1, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 
#<Listing id: 1, address: "123 Main Street", listing_type: "private room", title: "Beautiful Apartment on Main Street", description: "My apartment is great. there's a bedroom. close to...", price: #<BigDecimal:7fcb1a4dd900,'0.5E2',9(27)>, neighborhood_id: 1, host_id: 1, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 
#<Listing id: 1, address: "123 Main Street", listing_type: "private room", title: "Beautiful Apartment on Main Street", description: "My apartment is great. there's a bedroom. close to...", price: #<BigDecimal:7fcb1c80b698,'0.5E2',9(27)>, neighborhood_id: 1, host_id: 1, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 

#<Listing id: 2, address: "6 Maple Street", listing_type: "shared room", title: "Shared room in apartment", description: "shared a room with me because I'm poor", price: #<BigDecimal:7fcb1c809500,'0.15E2',9(27)>, neighborhood_id: 2, host_id: 2, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 

#<Listing id: 4, address: "4782 Yaya Lane", listing_type: "private room", title: "Beautiful Room in awesome house", description: "Art collective hosue.", price: #<BigDecimal:7fcb1b3a32c8,'0.4E3',9(27)>, neighborhood_id: 4, host_id: 3, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 

#<Listing id: 4, address: "4782 Yaya Lane", listing_type: "private room", title: "Beautiful Room in awesome house", description: "Art collective hosue.", price: #<BigDecimal:7fcb1b3a1ae0,'0.4E3',9(27)>, neighborhood_id: 4, host_id: 3, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">]


-----


With a final GROUP BY

    Listing.joins(:neighborhood).joins("LEFT OUTER JOIN reservations ON listings.id = reservations.listing_id").where(neighborhoods: {city_id: 1}, reservations: {id: nil})+Listing.joins(:neighborhood).joins(:reservations).where("neighborhoods.city_id = ? AND NOT ? BETWEEN reservations.checkin AND reservations.checkout AND NOT ? BETWEEN reservations.checkin AND reservations.checkout", 1, '2014-05-01', '2014-05-05').group("listings.id")


returns


[#<Listing id: 3, address: "44 Ridge Lane", listing_type: "whole house", title: "Beautiful Home on Mountain", description: "Whole house for rent on mountain. Many bedrooms.", price: #<BigDecimal:7fcb1c2b1238,'0.2E3',9(27)>, neighborhood_id: 3, host_id: 3, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 

#<Listing id: 1, address: "123 Main Street", listing_type: "private room", title: "Beautiful Apartment on Main Street", description: "My apartment is great. there's a bedroom. close to...", price: #<BigDecimal:7fcb1a3269b8,'0.5E2',9(27)>, neighborhood_id: 1, host_id: 1, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 

#<Listing id: 2, address: "6 Maple Street", listing_type: "shared room", title: "Shared room in apartment", description: "shared a room with me because I'm poor", price: #<BigDecimal:7fcb1a31f410,'0.15E2',9(27)>, neighborhood_id: 2, host_id: 2, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 

#<Listing id: 4, address: "4782 Yaya Lane", listing_type: "private room", title: "Beautiful Room in awesome house", description: "Art collective hosue.", price: #<BigDecimal:7fcb1a317d78,'0.4E3',9(27)>, neighborhood_id: 4, host_id: 3, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">]


---------


[#<Listing id: 3, address: "44 Ridge Lane", listing_type: "whole house", title: "Beautiful Home on Mountain", description: "Whole house for rent on mountain. Many bedrooms.", price: #<BigDecimal:7fcb1a5f6a30,'0.2E3',9(27)>, neighborhood_id: 3, host_id: 3, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, #

<Listing id: 1, address: "123 Main Street", listing_type: "private room", title: "Beautiful Apartment on Main Street", description: "My apartment is great. there's a bedroom. close to...", price: #<BigDecimal:7fcb1a5f4ff0,'0.5E2',9(27)>, neighborhood_id: 1, host_id: 1, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 

#<Listing id: 2, address: "6 Maple Street", listing_type: "shared room", title: "Shared room in apartment", description: "shared a room with me because I'm poor", price: #<BigDecimal:7fcb1a5ef9b0,'0.15E2',9(27)>, neighborhood_id: 2, host_id: 2, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">, 

#<Listing id: 4, address: "4782 Yaya Lane", listing_type: "private room", title: "Beautiful Room in awesome house", description: "Art collective hosue.", price: #<BigDecimal:7fcb1a5ee560,'0.4E3',9(27)>, neighborhood_id: 4, host_id: 3, created_at: "2016-12-03 10:47:14", updated_at: "2016-12-03 10:47:14">]

