class Neighborhood < ActiveRecord::Base
  include Filterable

  belongs_to :city
  has_many :listings

  def neighborhood_openings(time_one, time_two)
    self.send(:openings, time_one, time_two)
  end
end
