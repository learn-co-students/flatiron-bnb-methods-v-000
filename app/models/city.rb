class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  
  extend CityCalc::ClassMethods
  include CityCalc::InstanceMethods
  

end

