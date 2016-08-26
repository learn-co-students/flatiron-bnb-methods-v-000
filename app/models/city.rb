require 'pry'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start, fin)
    list = Listing.all
    
    list.where("created_at > ?", Date.parse(start)) && list.where("created_at < ?", Date.parse(fin))
  end

end
