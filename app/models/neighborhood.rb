class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  extend Reservable::ClassMethods
  include Reservable::InstanceMethods

  def neighborhood_openings(checkin, checkout)
    openings(checkin, checkout)
  end

end
