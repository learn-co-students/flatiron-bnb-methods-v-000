class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings
  extend Stats::ClassMethods
  include Stats::InstanceMethods

  def neighborhood_openings(start_date, end_date)
    self.openings(start_date, end_date)
  end

end
