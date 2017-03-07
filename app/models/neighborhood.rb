class Neighborhood < ActiveRecord::Base
  extend Sortable::ClassMethods
  include Sortable::InstanceMethods
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(checkin, checkout)
    listings.select do |listing|
      listing.reservations.none? do |reservation|
        (Date.parse(checkin) <= reservation.checkout) && (Date.parse(checkout) >= reservation.checkin)
        end
      end
    end

end
