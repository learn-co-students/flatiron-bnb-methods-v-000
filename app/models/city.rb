class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    openings = []
    Listing.all.each do |list|
      if list.available?(start_date, end_date)
        openings << list
      end
    end
    openings
  end

  def self.highest_ratio_res_to_listings
  end

  def self.most_res
  end

end
