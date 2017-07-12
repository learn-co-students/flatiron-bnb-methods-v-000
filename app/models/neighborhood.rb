class Neighborhood < ActiveRecord::Base
  include Shareable::InstanceMethods
  extend Shareable::ClassMethods

  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(checkin, checkout)
    overlap(checkin, checkout)
  end
end
