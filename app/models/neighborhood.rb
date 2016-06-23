require 'concerns/location_stats.rb'

class Neighborhood < ActiveRecord::Base
  include LocationStat

  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    openings(start_date, end_date)
  end
end
