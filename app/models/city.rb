require_relative '../../lib/ratios_extension.rb'

class City < ActiveRecord::Base
  include RatiosExtension
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date1, date2)
    #(date1 <= date2)
    Listing.all
  end

end
