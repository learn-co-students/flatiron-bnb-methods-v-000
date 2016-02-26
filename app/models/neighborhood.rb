class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  include Statistics

  def neighborhood_openings(*date)
    openings(*date)
  end

end
