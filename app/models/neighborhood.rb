class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  include Bnb

  def neighborhood_openings(startdate, enddate)
    available(startdate, enddate)
  end
end
