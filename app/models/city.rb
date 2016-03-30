require_relative './concerns/openings'
class City < ActiveRecord::Base
  include Openings::ForInstance
  extend Openings::ForClass

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(starting, ending)
    self.find_openings(starting.to_date, ending.to_date)
  end

end
