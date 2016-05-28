class Neighborhood < ActiveRecord::Base
  #extend ReservationRatios
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(date1, date2)
    #binding.pry
    self.reservations.collect do |reservation| 
      range = reservation.checkin..reservation.checkout
      if range === date1 || range === date2 
        nil
      else
        reservation.listing
        #binding.pry
      end
    end
  end

  def self.most_res
    self.all.max_by {|neighborhood| neighborhood.reservations.length}
  end
  
  def self.highest_ratio_res_to_listings
    neighborhood = self.all.max_by {|neighborhood| neighborhood.listings.length}
    self.most_res.reservations.length > neighborhood.listings.length ? self.most_res : neighborhood
  end

end
