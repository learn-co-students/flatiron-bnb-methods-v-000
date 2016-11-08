class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings
  
  def city_openings(start_date, end_date)
    parse_overlap(start_date, end_date)
  end
  
  def self.highest_ratio_res_to_listings
    self.all.max_by { |c| c.listings.count == 0 ? 0 : c.reservations.count / c.listings.count }
  end
  
  def self.most_res
    self.all.max_by { |c| c.reservations.count }
  end
  
  private
  
  def parse_overlap(start_date, end_date)
    self.listings.select do |listing|
      listing.reservations.none? do |reservation|
        (Date.parse(start_date) <= reservation.checkout) && (Date.parse(end_date) >= reservation.checkin) 
      end
    end
  end
end

