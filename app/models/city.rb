class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  include Available::InstanceMethods

  #city_openings method should return all of the Listing objects that are
  #available for the entire span that is inputted.

  def city_openings(start_date, end_date)
    openings(start_date, end_date)
  end

end
