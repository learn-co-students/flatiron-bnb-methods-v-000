class Neighborhood < ActiveRecord::Base
  include InstanceMethods
  extend SharedMethods

  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(start_date, end_date)
    parse_overlap(start_date, end_date)
  end

end
