class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  
  include Reservable

  def neighborhood_openings(startDate, endDate)
    openings(startDate, endDate)
  end

end