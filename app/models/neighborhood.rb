class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  include Measurable::InstanceMethods
  extend Measurable::ClassMethods

  def neighborhood_openings(startdate, enddate)
    self.listings.find_all {|listing| listing.available?(startdate, enddate)}
  end

end
