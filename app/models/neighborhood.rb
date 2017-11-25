class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  include Reservable

  def neighborhood_openings(d1, d2)
    openings(d1, d2)
  end

end
