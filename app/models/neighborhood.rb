class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def self.highest_ratio_res_to_listings
      @hood = Neighborhood.all.max_by { |hood| hood.ratio }
  end

  def self.most_res
      @hood = Neighborhood.all.max_by { |hood| hood.reservations.count }
  end

  def neighborhood_openings(start_date, end_date)
      reservations = self.reservations.select { |r| r.checkin > Date.parse(start_date) && r.checkout < Date.parse(end_date)}
  end

  def ratio
      unless self.listings.empty?
          self.reservations.count/self.listings.count
      else
          0
      end
  end
end
