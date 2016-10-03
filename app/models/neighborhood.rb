class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  include FindAvailableListings::InstanceMethods
  extend FindAvailableListings::ClassMethods
end
