class Neighborhood < ActiveRecord::Base
  include SharedInstanceMethods
  extend SharedClassMethods

  belongs_to :city
  has_many :listings

  def neighborhood_openings(check_in, check_out)
    self.listings.map do |listing|
      listing
    end
  end

end
