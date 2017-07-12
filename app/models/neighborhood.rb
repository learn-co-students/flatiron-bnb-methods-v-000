class Neighborhood < ActiveRecord::Base
  include InstanceMethods
  extend SharedMethods
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start, finish)
    parse_overlap(start, finish)
  end

end
