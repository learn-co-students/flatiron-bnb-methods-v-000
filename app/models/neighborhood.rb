class Neighborhood < ActiveRecord::Base
  include Reservable::InstanceMethods
  extend Reservable::ClassMethods

  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(arrive, depart)
    openings(arrive, depart)
  end

end
