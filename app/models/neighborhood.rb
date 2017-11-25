class Neighborhood < ActiveRecord::Base
  include Areas::InstanceAreas
  extend Areas::ClassAreas

  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin_date, checkout_date)
    openings(checkin_date, checkout_date)
  end

end
