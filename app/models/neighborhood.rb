class Neighborhood < ActiveRecord::Base
  ## See solution for cleaner and more descriptive methods :)

  belongs_to :city
  has_many :listings

  # Instance method
  def neighborhood_openings(start_date, end_date)
    self.listings.map do |listing|
      if listing.reservations.empty?
        [listing]
      else
        listing.reservations.map do |reservation|
          if (Date.strptime(end_date, '%Y-%m-%d') <= reservation.checkin || Date.strptime(start_date, '%Y-%m-%d') >= reservation.checkout)
            Listing.find_by(id: reservation.listing_id)
          end
        end
      end
    end.delete_if { |listing| listing.include?(nil) }.flatten.uniq
  end


  # Class methods
  def self.highest_ratio_res_to_listings
    avg_res_per_neighborhood = self.res_per_listing_per_neighborhood.map do |neighborhood_res|
      if neighborhood_res.empty?
        0
      else
        neighborhood_res.sum.to_f / neighborhood_res.count
      end
    end

    Neighborhood.find_by(id: (avg_res_per_neighborhood.each_with_index.max[1] + 1))
  end

  def self.most_res
    total_res_per_neighborhood = self.res_per_listing_per_neighborhood.map do |neighborhood_res|
      if neighborhood_res.empty?
        0
      else
        neighborhood_res.sum
      end
    end

    Neighborhood.find_by(id: (total_res_per_neighborhood.each_with_index.max[1] + 1))
  end


   # Helper method (and cleaning up repetitive code)
  def self.res_per_listing_per_neighborhood
    self.all.map do |neighborhood|
      neighborhood.listings.map do |listing|
        listing.reservations.count
      end
    end
  end
end
