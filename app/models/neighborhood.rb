class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


  def neighborhood_openings(start_s, end_s)
    start_d = Date.parse(start_s)
    end_d = Date.parse(end_s)
    available_res = self.listings
    self.listings.each do |l|
      l.reservations.each do |r|
        if start_d <= r.checkout && r.checkin <= end_d
          available_res - [l]
          break
        end
      end
      available_res
    end
  end

  def self.highest_ratio_res_to_listings
    ratios = Hash.new
    Neighborhood.all.each do |n|
      unless n.listings.count == 0
        ratios[n] = (n.reservations.count/n.listings.count)
      end
    end
    (ratios.max_by{|k,v| v})[0]
  end

  def self.most_res
    Neighborhood.joins(:reservations).
    select('neighborhoods.*, count(reservations.id) AS reservations_count').
    group("neighborhoods.id").
    order("reservations_count DESC").
    first
  end


end
