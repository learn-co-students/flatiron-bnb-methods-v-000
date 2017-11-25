class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    listings.each do |listing|
      listing.reservations.each do |reservation|
        start_date <= reservation.checkout.to_s && end_date >= reservation.checkin.to_s
      end
    end
  end

  def self.most_res
    hoods_with_reservations = {}
    all.each do |hood|
      res_counts = hood.listings.collect {|listing| listing.reservations.count}
      sum_of_reservations = res_counts.inject(0) {|sum, count| sum + count}
      hoods_with_reservations[hood] = sum_of_reservations
    end
    hoods_with_reservations.max_by {|hood, res| res}.first
  end

  def self.highest_ratio_res_to_listings
      ratios = {}
      self.all.each do |hood|
        if hood.listings.count > 0
          counter = 0
          hood.listings.each do |list|
            counter += list.reservations.count
          end
          ratios[hood] = counter/hood.listings.count
        end
      end
      ratios.key(ratios.values.sort.last)
    end

end
