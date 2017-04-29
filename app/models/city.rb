class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    self.listings.map do |listing|
      if start_date.to_i <= listing.created_at.to_i && listing.created_at.to_i <= end_date.to_i
        listing
      else
        nil
      end
    end
  end
end
