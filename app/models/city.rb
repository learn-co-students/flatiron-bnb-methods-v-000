class City < ActiveRecord::Base
  include FindableConcern::InstanceMethods
  extend FindableConcern::ClassMethods 

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings
end
