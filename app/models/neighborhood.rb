class Neighborhood < ActiveRecord::Base
  include Shareable
  extend Shareable::ClassMethods
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    openings(start_date, end_date)
  end

end
