class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  include Available::InstanceMethods
  extend Available::ClassMethods

  def neighborhood_openings(first_date, last_date)
    openings(first_date, last_date)
  end
end
