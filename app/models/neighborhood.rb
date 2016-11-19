class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(begin_date, end_date)
    hood_listings = []
    Listing.all.each do |l|
      if !l.reservations.empty?
        none = l.reservations.all.any? do |res|
          r = res.checkin.strftime('%Y-%m-%d')
          s = res.checkout.strftime('%Y-%m-%d')
          (begin_date..end_date).overlaps?(r..s)
        end
        if none == false && l.neighborhood == self
          hood_listings << l unless hood_listings.include?(l)
        end
      elsif !hood_listings.include?(l) && l.neighborhood == self
        hood_listings << l
      end
    end
    hood_listings
  end

  def self.highest_ratio_res_to_listings
    ratios = {}
    res_total.each do |hood, res_count|
      current_hood = self.find_by_name(hood)
      if res_count > 0
        ratios[hood] = (res_count / current_hood.listings.all.size)
      end
    end
    self.find_by_name(ratios.key(ratios.values.max))
  end

  def self.most_res
    self.find_by_name(res_total.key(res_total.values.max))
  end

  def self.res_total
    ratios = {}
    x = self.all.map do |c|
      ratios[c.name]=c.listings.all.map do |l|
        l.reservations.size
      end
    end
    ratios.each do |hood, array|
      ratios[hood] = array.inject(0){|sum, x| sum + x}
    end
  end
end
