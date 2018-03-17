class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  # Returns all of the available apartments in a city, given the date range
  def city_openings(start_date, end_date)
    booked_listings = "select distinct(l.id) FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id JOIN reservations r on l.id = r.listing_id WHERE r.checkin >= #{start_date} AND r.checkout <= #{end_date}"
    Listing.find_by_sql("select l.id, l.title FROM cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id WHERE l.id NOT IN (#{booked_listings})")
  end

  # Returns city with highest ratio of reservations to listings
  def self.highest_ratio_res_to_listings
    query = "select aggregate.id, aggregate.name, aggregate.listing_num, count(r.id) as res_num, count(cast(r.id as decimal)) / cast(listing_num as decimal) as ratio from (select c.id, c.name, count(l.id) as listing_num from cities c
            JOIN neighborhoods n on c.id = n.city_id
            JOIN listings l on n.id = l.neighborhood_id
            group by c.id, c.name) as aggregate
            JOIN neighborhoods n on aggregate.id = n.city_id
            JOIN listings l on n.id = l.neighborhood_id
            JOIN reservations r on l.id = r.listing_id
            group by aggregate.id, aggregate.name, aggregate.listing_num
            ORDER BY ratio DESC LIMIT 1"
    City.find_by_sql(query).first
  end

  # Returns city with most reservations
  def self.most_res
    City.find_by_sql("select c.id, c.name, COUNT(c.id) as num_res from cities c JOIN neighborhoods n on c.id = n.city_id JOIN listings l on n.id = l.neighborhood_id JOIN reservations r on l.id = r.listing_id group by c.id, c.name ORDER BY num_res DESC LIMIT 1").first
  end

end
