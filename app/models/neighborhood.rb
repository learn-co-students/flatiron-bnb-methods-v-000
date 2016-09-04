class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(ckin, ckout)
    open_listings = []
    self.listings.each do |listing|
      if !res_conflicts?(listing, ckin, ckout)
        open_listings << listing
      end
    end
    open_listings
  end

  def res_conflicts?(listing, ckin, ckout)
    ckin = ckin.to_date
    ckout = ckout.to_date

    listing.reservations.each do |res|
      if res.checkout > ckin && res.checkout < ckin
        return true
      elsif res.checkin > ckin && res.checkin < ckin
        return true
      end
    end
    return false
  end

end
