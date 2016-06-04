class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(first_date, second_date)
    openings = []
    self.listings.each do |listing|
      opening = true
      listing.reservations.each do |res|
        # binding.pry
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

  def self.highest_ratio_res_to_listings
    self.all.max do |a, b|
      (a.reservations.size.to_f / a.listings.size.to_f) <=> (b.reservations.size.to_f / b.listings.size.to_f)
    end
  end

  def self.most_res
    self.all.max do |a,b|
      # binding.pry
      a.reservations.size <=> b.reservations.size
    end
  end

end
