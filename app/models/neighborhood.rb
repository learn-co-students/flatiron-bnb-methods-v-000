class Neighborhood < ActiveRecord::Base
  include ReportableConcern::InstanceMethods
  extend ReportableConcern::ClassMethods

  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

end
