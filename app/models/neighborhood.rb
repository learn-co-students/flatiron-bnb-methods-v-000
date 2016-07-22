class Neighborhood < ActiveRecord::Base
  extend SharedMethods::ClassMethods
  include SharedMethods::InstanceMethods
  belongs_to :city
  has_many :listings
end
