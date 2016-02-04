require_relative './concerns/area_stats.rb'

class Neighborhood < ActiveRecord::Base
  extend AreaStats
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(start_date,end_date)
    self.city.city_openings(start_date,end_date).select do |opening| 
      opening.neighborhood_id = self.id
    end
  end

end
