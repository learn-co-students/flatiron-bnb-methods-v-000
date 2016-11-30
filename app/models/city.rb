class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date1, date2)
    self.listings.select{|l| l.start_date.strftime("%Y-%m-%d") < date1 && l.end_date.strftime("%Y-%m-%d") > date2}
  end

  def self.highest_ratio_res_to_listings
    query = "SELECT aggregate.id, aggregate.name, aggregate.listing_num, count(r.id) as res_num, count(cast(r.id as decimal)) / cast(listing_num as decimal) as ratio from (select c.id, c.name, count(l.id) as listing_num from cities c
             JOIN neighborhoods n on c.id = n.city_id
             JOIN listings l on n.id = l.neighborhood_id
             GROUP by c.id, c.name) as aggregate
             JOIN neighborhoods n on aggregate.id = n.city_id
             JOIN listings l on n.id = l.neighborhood_id
             JOIN reservations r on l.id = r.listing_id
             GROUP by aggregate.id, aggregate.name, aggregate.listing_num
             ORDER BY ratio DESC LIMIT 1"
    City.find_by_sql(query).first
  end

  def self.most_res
    query = "SELECT c.id, c.name, COUNT(c.id) as num_res from cities c
             JOIN neighborhoods n on c.id = n.city_id
             JOIN listings l on n.id = l.neighborhood_id
             JOIN reservations r on l.id = r.listing_id
             GROUP by c.id, c.name ORDER BY num_res DESC LIMIT 1"
    City.find_by_sql(query).first
  end

end
