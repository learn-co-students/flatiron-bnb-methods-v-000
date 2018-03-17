class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    self.listings.each do |l|
      l.reservations.collect do |r|
        if r.checkin == start_date && r.checkout ==end_dated
          l
        end
      end
    end
  end

  def self.highest_ratio_res_to_listings
    @all_hoods = []
    self.all.each do |n|
      if n.total_res != 0 && n.listings.count != 0
        @all_hoods << n
      end
    end
    @all_hoods.max_by {|n| n.total_res/n.listings.count}
  end

  def self.most_res
    self.all.max_by {|n| n.total_res}
  end

  def total_res
    @total = 0
    self.listings.each do |l|
      @total += l.reservations.count
    end
    @total
  end
end
