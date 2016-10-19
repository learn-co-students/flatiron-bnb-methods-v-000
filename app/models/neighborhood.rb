class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start, finish)
    available = []
    self.listings.each do |listing|
      listing.reservations.each do |res|
        if !res.checkin.between?(start.to_date, finish.to_date) && !res.checkout.between?(start.to_date, finish.to_date) && !start.to_date.between?(res.checkin, res.checkout) && !finish.to_date.between?(res.checkin, res.checkout)
          available << listing
        end
      end
    end
    available
  end

  def ratio_res_to_listings
    if self.listings.count > 0
      self.listings.inject(0) { |sum, listing| sum + listing.reservations.count }.to_f / self.listings.count.to_f
    else
      0
    end
  end

  def self.most_res
    all.max do |a, b|
      a.listings.inject(0) { |sum, listing| sum + listing.reservations.count }.to_f  <=> b.listings.inject(0) { |sum, listing| sum + listing.reservations.count }.to_f
    end
  end

  def self.highest_ratio_res_to_listings
    all.max do |a, b|
      a.ratio_res_to_listings <=> b.ratio_res_to_listings
    end
  end

end
