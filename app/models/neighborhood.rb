class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(check_in, check_out)
    min = Date.parse(check_in)
    max = Date.parse(check_out)
    @available = []

    listings.each do |listing|
      @available << listing unless listing.reservations.any? { |reservation| 
        (reservation.checkin.between?(min, max) && reservation.checkout.between?(min, max) ) 
      }
    end
    @available
  end

  def self.highest_ratio_res_to_listings
    ratio_res = {}

    self.all.each do |neighborhood|
      if neighborhood.listings.count > 0
      counter = 0
      neighborhood.listings.each do |x|
        counter += x.reservations.count 
      end
      ratio_res[neighborhood] = counter / neighborhood.listings.count 
    end
  end
    ratio_res.key(ratio_res.values.sort.last)
  end


  def self.most_res
    most_res = {}

    self.all.each do |neighborhood|
      counter = 0
      neighborhood.listings.each do |x|
        counter += x.reservations.count 
      end
      most_res[neighborhood] = counter 
    end
    most_res.key(most_res.values.sort.last)
  end

end
