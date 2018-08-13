class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  extend ArelTables, ListingStats::ClassMethods
  include ArelTables, ListingStats::InstanceMethods

  def city_openings(range_begin, range_end)
    find_openings(range_begin, range_end)
  end
end
