class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(start_date, end_date)
    self.listings.collect do |list|
      list if list.reservations.all? { |res| !((start_date.to_date <= res.checkout) && (res.checkin >= end_date.to_date))}
    end
  end

  def self.neighborhoods_with_listings
    self.all.map { |neighborhood| neighborhood if neighborhood.listings.count > 0 }.compact
  end

  def ratio
    self.reservations.count.to_f / self.listings.count
  end

  def self.highest_ratio_res_to_listings
    self.neighborhoods_with_listings.sort { |x, y| x.ratio <=> y.ratio }.last
  end

  # def self.highest_ratio_res_to_listings
  #   self.all.sort { |x, y| x.ratio <=> y.ratio }
  # end

  def self.most_res
    self.all.sort { |x, y| y.reservations.count <=> x.reservations.count }.first
  end

end
