class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(date1, date2)
    self.listings.reject {|listing| listing.reservations.any? {|reserve| reserve.checkin.to_s.between?(date1, date2)}}
  end

  def self.highest_ratio_res_to_listings
    ratios = self.all.collect do |neig|
      neig.reservations.count.to_f / neig.listings.count
    end
    ratios = ratios.collect do |int|
      (int.is_a?(Float) && int.nan?) ? 0 : int
    end
    max_index = ratios.index(ratios.max)
    self.all[max_index]
  end

  def self.most_res
    res_counts = self.all.collect {|hood| hood.reservations.count}
    max_index = res_counts.index(res_counts.max)
    self.all[max_index]
  end

end
