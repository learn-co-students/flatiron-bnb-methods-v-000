class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  # Return a city's available listing given a date range
  def city_openings(start_date, end_date)
    sql = <<-SQL
      listings.id NOT IN (
        SELECT distinct(listings.id) FROM listings
        JOIN reservations ON listings.id = reservations.listing_id
        WHERE reservations.checkin BETWEEN ? AND ?
              OR reservations.checkout BETWEEN ? AND ?
      )
    SQL

    listings.where(sql, start_date, end_date, start_date, end_date)
  end

  # Find the city withthe highest reservation to listing ratio
  def self.highest_ratio_res_to_listings
    order_sql = <<-SQL
      ((
        SELECT count(reservations.id) FROM reservations
        JOIN listings ON listings.id = reservations.listing_id
        JOIN neighborhoods ON neighborhoods.id = listings.neighborhood_id
        WHERE neighborhoods.city_id = cities.id
      ) / (
        SELECT count(listings.id) FROM listings
        JOIN neighborhoods ON neighborhoods.id = listings.neighborhood_id
        WHERE neighborhoods.city_id = cities.id
      )) DESC
    SQL

    self.order(order_sql).first
  end

  # Find city with the most reservations
  def self.most_res
    self.joins(:reservations).group('cities.id').
         order('count(reservations.id) DESC').first
  end

end

