class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    range = Date.parse(start_date)...Date.parse(end_date)
    output = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        if !range.include?(reservation.checkin) && !range.include?(reservation.checkout)
          output << listing
        end
      end
    end
    output
  end

  def self.highest_ratio_res_to_listings
    current = 0
    output = nil
    self.all.each do |n|
      unless n.listings.count == 0
        if n.reservations.count/n.listings.count > current
          current = n.reservations.count/n.listings.count
          output = n
        end
      end
    end
    output
  end

  def self.most_res
    current = 0
    output = nil
    self.all.each do |n|
      if n.reservations.count > current
        current = n.reservations.count
        output = n
      end
    end
    output
  end

end
