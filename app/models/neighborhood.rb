class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  include Reservable

  def neighborhood_openings(startdate, enddate)
  	Listing.all.each do |listing|
  		listing.reservations.each do |reserve|
  			startdate <= reserve.checkout.to_s && enddate >= reserve.checkin.to_s
  		end
  	end  	
  end


end
