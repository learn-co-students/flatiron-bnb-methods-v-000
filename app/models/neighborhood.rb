class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(date1, date2)
    first_date = Date.parse(date1)
    second_date = Date.parse(date2)

    @openings = []

    listings.each do |listing|
      @openings << listing unless listing.reservations.any? { |reservation|
        first_date.between?(reservation.checkin, reservation.checkout) &&
        second_date.between?(reservation.checkin, reservation.checkout) }
    end
      @openings
  end

  def self.highest_ratio_res_to_listings
    neighborhoods = {}
    neighborhood = ""

    self.all.each do |neighborhood|
      if neighborhood.reservations.count != 0 && neighborhood.listings.count != 0
        neighborhoods[neighborhood] = (neighborhood.reservations.count) / (neighborhood.listings.count)
      end
    end
    neighborhood = neighborhoods.key(neighborhoods.values.sort.last)
  end

  def self.most_res 
    neighborhood_res = {}
    neighborhood = ""

    self.all.each do |neighborhood|
      neighborhood_res[neighborhood] = neighborhood.reservations.count.to_i
    end
    neighborhood = neighborhood_res.key(neighborhood_res.values.sort.last)
  end

end


