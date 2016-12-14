class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    self.listings.each do |listing|
      listing.reservations.collect do |res|
        if res.checkin <= end_date.to_date && res.checkout >= start_date.to_date
          listing
        end
      end
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by do |neighborhood| 
      if neighborhood.listings.count == 0
        0
      else
        neighborhood.listings.map {|listing| listing.reservations.count}.sum/neighborhood.listings.count
      end
    end
  end

def self.most_res
    self.all.max_by do |neighborhood|
      neighborhood.listings.map {|listing| listing.reservations.count}.sum
    end
  end
end
