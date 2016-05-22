class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

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


end

