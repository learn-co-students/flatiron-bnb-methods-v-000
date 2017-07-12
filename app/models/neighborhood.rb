class Neighborhood < ActiveRecord::Base
  extend SharedClass
  include SharedInstance
  belongs_to :city
  has_many :listings

  def neighborhood_openings(starting, ending)
    openings(starting, ending)
  end

end
