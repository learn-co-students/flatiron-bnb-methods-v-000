class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  
  has_many :reservations, through: :listings

  def neighborhood_openings(beginning_date, end_date)
    self.listings.reject {|l| l.reservations.any? {|r| r.checkin.to_s.between?(beginning_date, end_date)}}
  end
  def self.highest_ratio_res_to_listings
    ratios = self.all.collect do |n|
      n.reservations.count.to_f / n.listings.count
    end
    ratios = ratios.collect {|i| (i.is_a?(Float) && i.nan?) ? 0 : i}
    max_index = ratios.index(ratios.max)
    self.all[max_index]
  end

  def self.most_res
    count = self.all.collect {|i| i.reservations.count}
    max_index = count.index(count.max)
    self.all[max_index]
  end
end
