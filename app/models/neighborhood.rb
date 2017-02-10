class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
 #knows avil. listings given date range
  def neighborhood_openings(beg_date, end_date)
    self.listings do |listing|
      collection = []
      listing.reservations.each do |one|
        dates = beg_date..end_date
        if one.checkin === dates && one.checkout === dates
          false
        else
          collection << listing
        end
      end
      collection 
    end
  end

end
