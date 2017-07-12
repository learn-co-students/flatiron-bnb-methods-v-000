class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  include Stats::InstanceMethods
  extend Stats::ClassMethods

  def city_openings(start_date, end_date)
    openings(start_date, end_date)
  end

end
