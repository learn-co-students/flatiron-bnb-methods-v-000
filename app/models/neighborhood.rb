class Neighborhood < ActiveRecord::Base

  include Reportable::InstanceMethods
  extend Reportable::ClassMethods

  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(checkin, checkout)
    openings(checkin, checkout)
  end

end
