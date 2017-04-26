class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(date1, date2) #find a reservation by listing_id?
    lists = Listing.all
    lists.each do |listing|
      Reservation.find_by(listing_id: self.id)
    end
    #lists.select {|list| list.reservations} #??
  end

end
