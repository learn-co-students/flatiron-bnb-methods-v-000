class City < ActiveRecord::Base
  require_relative 'openings'
  require_relative 'res'
  include Openings
  extend Res
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date1, date2)
    self.openings(date1, date2)
  end

end
