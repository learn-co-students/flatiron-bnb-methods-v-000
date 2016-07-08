class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    sd = Date.parse(start_date)
    ed = Date.parse(end_date)
    @available = Listing.all.reject do |l|
      l.reservations.any? do |r|
        (r.checkin >= sd && r.checkin <= ed) ||
        (r.checkout <= ed && r.checkout >= sd) ||
        (r.checkin <= sd && r.checkout >= ed)
      end
    end
    @available
  end

  def res_to_listings
    if listings.count > 0
      reservations.size.to_f / listings.size.to_f
    else
      0
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max do |a, b|
      a.res_to_listings <=> b.res_to_listings
    end
  end

  def self.most_res
    self.all.max do |a, b|
      a.reservations.size <=> b.reservations.size
    end
  end

end
