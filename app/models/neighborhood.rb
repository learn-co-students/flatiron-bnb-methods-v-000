class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  include Reservable

  def neighborhood_openings(start_date, end_date)
    Listing.all.each do |listing|
      listing.reservations.each do |res|
        start_date <= res.checkout.to_s && end_date >= res.checkin.to_s
      end
    end
  end
end