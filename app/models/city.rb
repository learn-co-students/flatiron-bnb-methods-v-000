class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  include Reservable

  def city_openings(startdate, enddate)
  	Listing.all.each do |listing|
  		listing.reservations.each do |reserve|
  			startdate <= reserve.checkout.to_s && enddate >= reserve.checkin.to_s
  		end
  	end  	
  end

end

