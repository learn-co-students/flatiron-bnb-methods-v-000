class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  extend Localeable::ClassMethods
  include Localeable::InstanceMethods
  
  def neighborhood_openings(checkin, checkout)
    locale_openings(checkin, checkout)
  end
end
