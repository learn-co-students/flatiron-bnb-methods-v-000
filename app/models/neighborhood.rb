class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    @start_date = start_date
    @end_date =  end_date

    self.listings.where ("listings.id not IN (SELECT listing_id from reservations WHERE (@start_date <= checkout) and (checkin <= @end_date))")
  end

  def self.most_res
    self.find_by_sql("SELECT neighborhoods.*, count(*)
    FROM neighborhoods
    INNER JOIN listings ON neighborhoods.id = listings.neighborhood_id
    INNER JOIN reservations ON listings.id = reservations.listing_id
    GROUP BY neighborhoods.id
    ORDER BY count(*) desc").first
  end

  def self.highest_ratio_res_to_listings
    ratio_hash = {}
    @neighborhoods = Neighborhood.all
    @neighborhoods.each do |neighborhood|
      listing_count = ActiveRecord::Base.connection.execute("select count(*)
      from listings
      inner join neighborhoods
      on listings.neighborhood_id = neighborhoods.id
      where neighborhoods.id = #{neighborhood.id}")

      reservation_count = ActiveRecord::Base.connection.execute("select count(*)
      from reservations
      inner join listings
      on reservations.listing_id = listings.id
      inner join neighborhoods
      on listings.neighborhood_id = neighborhoods.id
      where neighborhoods.id = #{neighborhood.id}")

      ratio = reservation_count[0][0].to_f / listing_count[0][0].to_f
      ratio_hash["#{neighborhood.name}"] = ratio if !ratio.nan?
    end
      Neighborhood.find_by(name: ratio_hash.key(ratio_hash.values.max))
  end
end
