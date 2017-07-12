class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  include CommonTasks::InstanceMethods
  extend CommonTasks::ClassMethods

  def neighborhood_openings(date_1, date_2)
    openings(date_1, date_2)
  end
end
