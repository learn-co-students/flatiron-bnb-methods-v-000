class City < ActiveRecord::Base
  include Stats::InstanceMethods
  extend Stats::ClassMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
    listings.select {|listing| !listing.booked?(start_date, end_date)}
  end

end

