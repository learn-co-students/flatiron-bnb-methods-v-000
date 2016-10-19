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

  def self.highest_ratio_res_to_listings
    ratios = {}
    Neighborhood.all.each do |n|

    end
  end

  def self.most_res
    array = Listing.all.collect {|listing| listing.neighborhood_id}
    freq = array.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    Neighborhood.find(array.max_by { |v| freq[v] } )
  end

end
