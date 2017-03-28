class City < ActiveRecord::Base
  include ReportableConcern::InstanceMethods
  extend ReportableConcern::ClassMethods

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

end
