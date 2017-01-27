class City < ActiveRecord::Base

  include Filterable

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(time_one, time_two)
    self.send(:openings, time_one, time_two)
  end

  private

end
