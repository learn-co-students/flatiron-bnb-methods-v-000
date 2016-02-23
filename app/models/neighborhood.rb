class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  extend Superlifiable::ClassMethods

  def neighborhood_openings(date_1, date_2)
    start_date = Date.parse(date_1)
    end_date = Date.parse(date_2)
    available_listings = []

    listings.each do |listing|
      unless listing.reservations.any? { |res| start_date.between?(res.checkin, res.checkout) || end_date.between?(res.checkin, res.checkout) }
        available_listings << listing
      end
    end

    available_listings
  end

end
