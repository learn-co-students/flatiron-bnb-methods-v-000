class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  extend Localeable::ClassMethods
  include Localeable::InstanceMethods

  def city_openings(checkin, checkout)
    locale_openings(checkin, checkout)
  end
end
