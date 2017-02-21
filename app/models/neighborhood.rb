class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  extend SharedMethods::ClassMethods
  include ApplicationHelper

  def neighborhood_openings(date1, date2)
  	find_openings(date1, date2)
  end
end
