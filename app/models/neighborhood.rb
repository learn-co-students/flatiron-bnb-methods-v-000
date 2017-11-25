class Neighborhood < ActiveRecord::Base
  include Cityhoods
  extend ClassMethods
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(in_date, out_date)
  	self.openings(in_date, out_date)
  end
end
