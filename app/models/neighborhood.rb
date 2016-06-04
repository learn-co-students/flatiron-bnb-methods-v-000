class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(first_date, second_date)
    openings = []
    self.listings.each do |listing|
      opening = true
      listing.reservations.each do |res|
        if (res.checkin < second_date.to_date && res.checkout > second_date.to_date) || (res.checkin < first_date.to_date && res.checkout > first_date.to_date)
          opening = false
        end
      end
      if opening
        openings << listing
      end
    end
    openings
  end

  def res_to_listings
    # binding.pry
    if listings.count > 0
      reservations.size.to_f / listings.size.to_f
    else
      0
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max do |a, b|
      # binding.pry
      a.res_to_listings <=> b.res_to_listings
    end
  end

  def self.most_res
    self.all.max do |a,b|
      a.reservations.size <=> b.reservations.size
    end
  end

end
