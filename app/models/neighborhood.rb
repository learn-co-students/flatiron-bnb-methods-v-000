class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(date1, date2)
    date1 = Date.parse(date1)
    date2 = Date.parse(date2)
    available_listings = []
    listings.map do |listing| 
      if listing.reservations.none? { |res|  res.checkin.between?(date1, date2) && res.checkout.between?(date1, date2) }
        available_listings << listing
      end
    end
    available_listings
  end

  def self.highest_ratio_res_to_listings
    highest_ratio_hood = ""
    highest_ratio = 0

    self.all.map do |hood|

      if hood.reservations.count == 0 || hood.listings.count == 0
        hood_ratio = 0
      else
        hood_ratio = hood.reservations.count/hood.listings.count.to_r
      end

      if hood_ratio  > highest_ratio
        highest_ratio_hood = hood
        highest_ratio = hood_ratio
      end

    end
    highest_ratio_hood
  end

    def self.most_res
    most_res_hood = ""
    most_res = 0

    self.all.map do |hood|
      reservations_num = hood.listings.map { |listing| listing.reservations}.flatten.count

      if reservations_num  > most_res
        most_res_hood = hood
        most_res = reservations_num 
      end
    end
    most_res_hood
  end


end
