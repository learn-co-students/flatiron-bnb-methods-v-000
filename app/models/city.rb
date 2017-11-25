class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods

  def city_openings(start_date, end_date)
    listings.where(start_date, end_date)
  end

  def self.highest_ratio_res_to_listings
    hoods = all.select { |n| n.listings.count > 0 }
    ratios = hoods.collect { |c| [c, (c.reservations.count.to_f / c.listings.count.to_f * 100).to_i] }
    ratios.sort_by { |_c, r| r }.last[0]
  end

  def self.most_res
    all.sort_by { |n| n.reservations.count }.last
  end

  def reservations
    listings.collect(&:reservations).flatten
  end
end
