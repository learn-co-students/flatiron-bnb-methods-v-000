class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    self.listings.each do |list|
      list.reservations.collect do |res|
        if res.checkin == start_date && res.checkout == end_date
          list
        end
      end
    end
  end

  def ratio_res_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    end
  end

  def self.highest_ratio_res_to_listings
    @all_neighbors = []
    self.all.each do |n|
      if n.total_res != 0 && n.listings.count != 0
        @all_neighbors << n
      end
    end
    @all_neighbors.max_by {|n| n.total_res / n.listings.count}
  end

  def total_res
    @total = 0
    self.listings.each do |list|
      @total += list.reservations.count
    end
    @total
  end

  def self.most_res
    all.max do |a, b|
      a.reservations.count <=> b.reservations.count
    end
  end

end
