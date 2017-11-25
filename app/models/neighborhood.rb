class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  include Listable

  def neighborhood_openings(start_date_string, end_date_string)
    openings(start_date_string, end_date_string)
  end
end
