class City < ActiveRecord::Base
  include Openings
  extend Reservalyze
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(begin_date, end_date)
    open_listings(begin_date, end_date)
  end

end
