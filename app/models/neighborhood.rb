class Neighborhood < ActiveRecord::Base
  extend Sortable::ClassMethods
  include Sortable::InstanceMethods
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

end
