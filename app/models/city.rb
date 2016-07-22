class City < ActiveRecord::Base
  extend SharedMethods::ClassMethods
  include SharedMethods::InstanceMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
end

