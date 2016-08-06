class Neighborhood < ActiveRecord::Base
  require_relative 'openings'
  include Openings
  extend Openings
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(date1, date2)
    self.openings(date1, date2)
  end
end
