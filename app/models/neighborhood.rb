require_relative 'city'
class Neighborhood < ActiveRecord::Base
  extend Location
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    st_dt = Date.parse(start_date)
    ed_dt = Date.parse(end_date)
    openings = []
    conflict_rez = []
    self.listings.each do |listing|
      listing.reservations.each do |rez|
        if rez.checkin <= ed_dt && rez.checkout >= st_dt
          conflict_rez << rez
        end
      end
      if conflict_rez.empty?
        openings << listing
      end
      conflict_rez.clear
    end
    openings
  end

end
