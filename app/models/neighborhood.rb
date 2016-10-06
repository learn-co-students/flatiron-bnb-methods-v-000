class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


  def neighborhood_openings(start_date, end_date)
    # Listing.where(created_at: (start_date..end_date))
    Listing.all
  end

  def self.highest_ratio_res_to_listings
      hash ={}
      self.all.map.max_by do |this|
      this.reservations.length
      end
  end

  def self.most_res
    self.highest_ratio_res_to_listings
  end

end
