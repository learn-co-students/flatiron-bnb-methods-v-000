class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  include Reservable

  def city_openings(date1, date2)
    self.listings.where.not(id: bad_listing(date1, date2))
  end

  



  # City.first.listings.group(:neighborhood_id).count - gives hash of each neighborhood and number of listings
  # Reservation.group(:listing_id).count - gives hash of listing_ids and the number of listings


  # Reservation.all.where("checkin <= ? AND checkout >= ?", '2014-05-05', '2014-05-01')
  # This gets me any reservations that fall within that time frame
  # Now I want to get the listing_id and find listings that do NOT equal that id
  # bad_listing gets me the ids of the bad listings
end
