class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  include LocationQuerys
  extend LocationQuerys::ClassMethods

  def neighborhood_openings(begin_date, end_date)
    self.listings.collect do |listing|
      if !listing.listing_reserved?(begin_date, end_date)
        listing
      end
    end
  end

end
