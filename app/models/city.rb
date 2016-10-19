class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start, finish)
    available = []
    self.neighborhoods.each do |neighborhood|
      neighborhood.listings.each do |listing|
        available << listing if listing.reservations.empty?
        listing.reservations.each do |res|
          if !res.checkin.between?(start.to_date, finish.to_date) && !res.checkout.between?(start.to_date, finish.to_date) # && !start.to_date.between?(res.checkin, res.checkout) && !finish.to_date.between?(res.checkin, res.checkout)
            available << res.listing unless available.include?(res.listing)
          end
        end
      end
    end
    available
  end

  def ratio_res_to_listings
    if Listing.all.count > 0
      Reservation.all.count.to_f / Listing.all.count.to_f
    else
      0
    end
  end

  def self.most_res
    all.max do |a, b|
      a.listings.collect {|listing| listing.reservations}.count  <=> b.listings.collect {|listing| listing.reservations}.count
    end
  end

  def self.highest_ratio_res_to_listings
    all.max do |a, b|
      a.ratio_res_to_listings <=> b.ratio_res_to_listings
    end
  end

end
