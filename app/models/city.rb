class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  include Listable

  def city_openings(start_date_string, end_date_string)
    openings(start_date_string, end_date_string)
  end
end

