class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


  def neighborhood_openings(start, fin)
    self.listings.select{|l| l.available(start, fin)}
  end

  def self.highest_ratio_res_to_listings
# binding.pry
    hoods=self.all.select{|n| n.listings.count > 0}
    ratios=hoods.collect{|c| [c, (c.reservations.count.to_f/c.listings.count.to_f*100).to_i]}
    ratios.sort_by{|c, r| r}.last[0]
  end

  def self.most_res

    self.all.sort_by{|n|n.reservations.count}.last
# binding.pry
  end

  def reservations
    self.listings.collect{|l| l.reservations}.flatten
  end

end
