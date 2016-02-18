class Neighborhood < ActiveRecord::Base
  include Stats::InstanceMethods
  extend Stats::ClassMethods

  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    listings.select {|listing| !listing.booked?(start_date, end_date)}
  end

end
