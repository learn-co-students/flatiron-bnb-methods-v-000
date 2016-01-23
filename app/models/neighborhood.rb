class Neighborhood < ActiveRecord::Base
  include FindableConcern::InstanceMethods
  extend FindableConcern::ClassMethods

  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings
end
