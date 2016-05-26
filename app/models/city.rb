require_relative '../../lib/ratios_extension.rb'

class City < ActiveRecord::Base
  extend RatiosExtension

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date1, date2)
    #(date1 <= date2)
    
  end

  
end
