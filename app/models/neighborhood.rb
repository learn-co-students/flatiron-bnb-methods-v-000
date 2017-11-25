class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


  def neighborhood_openings(checkin, checkout)
    listings.each do |l|
      l.reservations.map do |r|
        r.checkin == checkin && r.checkout == checkout
      end
    end
  end

  def self.highest_ratio_res_to_listings
    ratio = Hash.new
    Neighborhood.all.each do |n|
      ratio[n] = n.reservations.count/n.listings.count unless n.listings.count == 0
    end
    ratio.max_by{|k,v| v}.first
  end

  def self.most_res
    most_reservations = Hash.new
    Neighborhood.all.each do |n|
      most_reservations[n] = n.reservations.count
    end
    most_reservations.max_by{|k,v| v}.first
  end


end
