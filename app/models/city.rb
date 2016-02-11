class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(check_in, check_out)
  #   min = Date.parse(check_in)
  #   max = Date.parse(check_out)
  #   @available = []

  #   listings.each do |listing|
  #     @availabe << listing unless listing.reservations.any? { |reservation| (min..max).overlaps? (reservation.checkin..reservation.checkout) }
  #   end
  #   @available
  # end

  listings.each do |list|
    list
  end
end

  def self.highest_ratio_res_to_listings
    ## return the City that is "most full". highest num reserv per listing
  end

  def self.most_res
    ##return city with most total num of reservations
  end

end ## class end 

