class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  extend CityCalc::ClassMethods
  include CityCalc::InstanceMethods
  
  def neighborhood_openings(start, finish)
    city_openings(start, finish)
  end
end
