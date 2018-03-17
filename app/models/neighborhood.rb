class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  extend Available::ClassMethods
  include Available::InstanceMethods

  def neighborhood_openings(date1, date2)
    openings(date1, date2)
  end
end
