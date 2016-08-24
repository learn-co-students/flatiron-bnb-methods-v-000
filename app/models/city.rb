class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  include Reservable

  def city_openings(start_date, end_date)
    Listing.all.each do |listing|
      listing.reservations.each do |res|
        start_date <= res.checkout.to_s && end_date >= res.checkin.to_s
      end
    end
  end

end
