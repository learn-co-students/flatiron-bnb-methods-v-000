class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  extend SharedMethods::ClassMethods
  include ApplicationHelper

  def city_openings(date1, date2)
    find_openings(date1, date2)
  end


end

