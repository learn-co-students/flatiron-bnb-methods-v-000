class Neighborhood < ActiveRecord::Base
  include Openings
  extend Reservalyze
  belongs_to :city
  has_many :listings

  def neighborhood_openings(begin_date, end_date)
    open_listings(begin_date, end_date)
  end
end
