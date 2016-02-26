class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  include Statistics

  def city_openings(*date)
    openings(*date)
  end

end

