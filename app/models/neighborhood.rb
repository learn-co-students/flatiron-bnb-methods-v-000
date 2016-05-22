class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  # Return a city's available listing given a date range
  def neighborhood_openings(start_date, end_date)
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

  # Find the neighborhood with the highest reservation to listing ratio
  def self.highest_ratio_res_to_listings
    order_sql = <<-SQL
      ((
        SELECT count(reservations.id) FROM reservations
        JOIN listings ON listings.id = reservations.listing_id
        WHERE listings.neighborhood_id = neighborhoods.id
      ) / (
        SELECT count(listings.id) FROM listings
        WHERE listings.neighborhood_id = neighborhoods.id
      )) DESC
    SQL

    order(order_sql).first
  end

  # Find neighborhood with the most reservations
  def self.most_res
    joins(:reservations).group('neighborhoods.id').
         order('count(reservations.id) DESC').first
  end
end
