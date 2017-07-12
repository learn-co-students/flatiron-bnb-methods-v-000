class City < ActiveRecord::Base
  include Statistics::InstanceMethods
  extend  Statistics::ClassMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    openings(start_date,end_date)
  end

end

