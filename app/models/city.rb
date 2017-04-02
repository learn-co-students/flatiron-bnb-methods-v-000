require 'pry'
class City < ActiveRecord::Base
  extend Reserve::ClassMethods
  include Reserve::InstanceMethods
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(in_day, out_day)
    openings(in_day, out_day)
  end

end
