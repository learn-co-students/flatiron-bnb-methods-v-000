class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(date_one,date_two)
    range = date_one..date_two
    openings = []
    self.listings.each do |listing|
      flag = true

      listing.reservations.each do |reservation|
        reserve_range = reservation.checkin..reservation.checkout
        if range.overlaps?(reserve_range)
          flag = false 
        end
      end  

      openings << listing unless flag == false
    end
  end

  def self.highest_ratio_res_to_listings
    neighborhoods = self.all 
    ratio = {} 
    neighborhoods.each do |n|
      listing_count = n.listings.count 
      reservation_count = n.reservations.count
      ratio[n.name] = (reservation_count/listing_count.to_f) unless listing_count == 0
    end
    # binding.pry
    highest = ratio.max_by{|key,value| value}
    self.find_by(name: highest[0])
  end

  def self.most_res
    neighborhoods = self.all 
    reservation_counts = {}

    neighborhoods.each do |n|
      number_of_res = n.reservations.count
      reservation_counts[n.name] = number_of_res
    end
    most = reservation_counts.max_by{|key,value| value}
    self.find_by(name: most[0])
  end
end
