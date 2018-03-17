class Neighborhood < ActiveRecord::Base
  include ResultableConcern::InstanceMethods
  extend ResultableConcern::ClassMethods

  belongs_to :city
  has_many :listings

  def neighborhood_openings(start, finish)
    find_openings(start, finish)
  end
end
