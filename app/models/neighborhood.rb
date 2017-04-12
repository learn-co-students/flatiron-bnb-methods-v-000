class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings
  validates_presence_of :name, :city_id

  extend Reservable::ClassMethods
  include Reservable::InstanceMethods

  def neighborhood_openings(start_date, end_date)
    openings = Reservation.openings(start_date, end_date) & reservations

    openings
  end

end
