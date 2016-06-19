class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  include Reservable

  def neighborhood_openings(date1, date2)
    self.listings.where.not(id: bad_listing(date1, date2))
  end

end
