class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  extend StatusMethods::ClassMethods
  #include StatusMethods::InstanceMethods

  def neighborhood_openings(checkin, checkout)
    requested_dates = ((Date.parse(checkin))..(Date.parse(checkout))).collect {|day| day}
    self.listings.select do |listing|
      if listing.dates_occupied
        requested_dates.none?{|date| listing.dates_occupied.include?(date)}
      else
        listing
      end
    end
  end

end
