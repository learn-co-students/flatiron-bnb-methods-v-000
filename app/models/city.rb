class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def city_openings(start_date, end_date)
    sd = Date.parse(start_date)
    ed = Date.parse(end_date)
    @available = Listing.all.reject do |l|
      l.reservations.any? do |r|
        (r.checkin >= sd && r.checkin <= ed) ||
        (r.checkout <= ed && r.checkout >= sd) ||
        (r.checkin <= sd && r.checkout >= ed)
      end
    end
    @available.select do |listing|
      listing.neighborhood.city == self
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max do |a, b|
      a.reservations.size.to_f / a.listings.size.to_f <=> b.reservations.size.to_f / b.listings.size.to_f
    end

    # city_listings = self.all.each do |city|
    #   city.listings
    # end
    #
    # city_reservations = self.all.each do |city|
    #   city.neighborhoods.each do |n|
    #     n.reservations
    #   end
    # end
    #
    # (city_listings.size / city_reservations.size).sort.last

  end

  def self.most_res
    self.all.max do |a, b|
      a.reservations.size <=> b.reservations.size
    end
  end



end
