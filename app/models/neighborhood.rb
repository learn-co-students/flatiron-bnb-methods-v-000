class Neighborhood < ActiveRecord::Base
  require_relative 'openings'
  require_relative 'res'
  include Openings
  extend Res
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(date1, date2)
    self.openings(date1, date2)
  end
end
