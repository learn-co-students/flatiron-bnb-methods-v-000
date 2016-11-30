class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(date1, date2)
    self.listings.select{|l| l.start_date.strftime("%Y-%m-%d") < date1 && l.end_date.strftime("%Y-%m-%d") > date2}
  end

  def self.highest_ratio_res_to_listings
    query = "SELECT n.id, n.name, COUNT(n.name) as res_count from neighborhoods n
            JOIN listings l on n.id = l.neighborhood_id
            JOIN reservations r on l.id = r.listing_id
            GROUP BY n.id, n.name
            ORDER BY res_count DESC LIMIT 1"
    Neighborhood.find_by_sql(query).first
  end

  def self.most_res
    query = "SELECT n.id, n.name, COUNT(n.name) as res_count from neighborhoods n
             JOIN listings l on n.id = l.neighborhood_id
             JOIN reservations r on l.id = r.listing_id
             GROUP BY n.id, n.name
             ORDER BY res_count DESC LIMIT 1"
    Neighborhood.find_by_sql(query).first
  end

end
