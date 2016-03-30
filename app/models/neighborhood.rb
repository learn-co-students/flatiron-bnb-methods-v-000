require_relative './concerns/openings'
class Neighborhood < ActiveRecord::Base
  include Openings::ForInstance
  extend Openings::ForClass

  belongs_to :city
  has_many :listings


  def neighborhood_openings(starting, ending)
    self.find_openings(starting.to_date, ending.to_date)
  end

end
