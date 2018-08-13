class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  extend ArelTables, ListingStats::ClassMethods
  include ArelTables, ListingStats::InstanceMethods

  def neighborhood_openings(range_begin, range_end)
    find_openings(range_begin,range_end)
  end

end