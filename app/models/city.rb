class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  include Measurable::InstanceMethods
  extend Measurable::ClassMethods

  # knows about all the available listings given a date range
  def city_openings(startdate, enddate)
    self.listings.find_all {|listing| listing.available?(startdate, enddate)}
  end

end
