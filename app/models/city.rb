class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  extend SearchConcerns::ClassMethods
  include SearchConcerns::InstanceMethods

  def city_openings(start_range, end_range)
      openings(start_range, end_range)
  end

end

