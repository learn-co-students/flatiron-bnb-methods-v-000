class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  validates :name, presence: true

  def city_openings(date_1, date_2)
    Listing.all
  end

  def self.highest_ratio_res_to_listings
      hash ={}
      self.all.map.max_by do |city|
        hash["#{city.name}"] = city.reservations
        hash["#{city.name}"][-1]
      end
  end

  def self.most_res
    self.highest_ratio_res_to_listings
  end
  private

end
