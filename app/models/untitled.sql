Listings average rating
select l.name, avg(r.rating) as avg_rating from listings l
join reservations r on r.listing_id = listings.id
join reviews re on r.id = re.reservation_id
group by l.name


listings    reviews

id           listing_id rating

1                1        4
                 1        5
2


name avg_rating

Listing.joins("LEFT JOIN RESERVATIONS R ON R.listing_id = listings.id", "LEFT JOIN REVIEWS RE ON RE.reservation_id = R.id").select("listings.title, AVG(rating) as 'avg_rating'").where("listings.id = ?", 1).first.avg_rating

# Returns all of the available apartments in a city, given the date range
func(start_date, end_date)
goal is to get back all the listings and their ids
city
select l.id, l.title FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id WHERE l.id NOT IN ()"


"select distinct(l.id) FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id JOIN reservations r on l.id = r.listing_id 
WHERE r.checkin >= '2014-01-08' AND r.checkout <= '2014-05-21'"

"select l.id as listing_id, l.title as title FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id WHERE l.id NOT IN (select distinct(l.id) FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id JOIN reservations r on l.id = r.listing_id WHERE r.checkin >= '2014-01-08' AND r.checkout <= '2014-05-21')"

# city with the most reservations
city_id #of reservations
select * from cities c
JOIN neighborhoods n on c.id = n.city_id
JOIN listings l on n.id = l.neighborhood_id