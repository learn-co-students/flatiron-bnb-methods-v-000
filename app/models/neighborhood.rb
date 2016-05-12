class Neighborhood < ActiveRecord::Base
  include Resultable::InstanceMethods
  extend Resultable::ClassMethods

  belongs_to :city
  has_many :listings

end
