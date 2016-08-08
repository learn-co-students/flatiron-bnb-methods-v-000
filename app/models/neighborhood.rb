class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    listings.each do |list|
      list.reservations.collect do |res|
        res.checkin == start_date && res.checkout == end_date
      end
    end
  end

  def self.highest_ratio_res_to_listings
    @all_neighbors = []
    all.each { |n| @all_neighbors << n if n.listings.count != 0 }
    @all_neighbors.max_by { |n| n.total_res / n.listings.count }
  end

  def total_res
    listings.collect { |list| list.reservations.count }.reduce(:+)
  end

  def self.most_res
    all.max_by { |n| n.reservations.count }
  end
end
