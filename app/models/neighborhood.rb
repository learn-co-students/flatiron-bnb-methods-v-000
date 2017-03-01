class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  extend StatusMethods::ClassMethods
  include StatusMethods::InstanceMethods

end
