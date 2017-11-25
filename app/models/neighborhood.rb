class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(startdate, enddate)
    self.listings.find_all {|l| l.available?(startdate, enddate)}
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by do |n| 
      if n.listings.count > 0
        ratio = n.total_reservation.to_f / n.listings.count
      else
        ratio = 0
      end
      ratio
    end  
  end

  def self.most_res
    self.all.max_by do |n| 
      n.total_reservation
    end
  end

  def total_reservation
    total_reservation = 0
    self.listings.each do |t|
      total_reservation += t.reservations.count
    end
    total_reservation
  end

end
