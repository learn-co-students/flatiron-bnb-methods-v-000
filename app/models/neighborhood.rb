class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(arrival, departure)
    Listing.all.select do |alisting|
      alisting.reservations.find{ |res| Date.parse(arrival).between?(res.checkin, res.checkout) || Date.parse(departure).between?(res.checkin, res.checkout)}.nil?
    end
  end

   def total_reservation_count
    total_res_count = 0
    self.listings.each do |listing|
      total_res_count += listing.reservation_count 
    end
    total_res_count
  end

  def ratio
    if self.listings.count != 0
      ratio = (self.total_reservation_count / self.listings.count)  
    else
      ratio = 0
    end
  end

  def self.highest_ratio_res_to_listings 
    popular_res = self.all.max_by do |area| 
       area.ratio
    end
    popular_res
  end

  def self.most_res
    popular_area = self.all.max_by do |area|
      area.total_reservation_count
    end
    popular_area
  end

end
