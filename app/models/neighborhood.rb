class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  include Available

  def neighborhood_openings(checkin, checkout)
    openings(checkin, checkout)
  end

end
