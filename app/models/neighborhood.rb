class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def count_reservations
    # self.listings.inject(0) { |sum, lst| sum + lst.reservations.count }
    self.listings.joins(:reservations).count
  end

  def neighborhood_openings(date1, date2)
    # this can be done using querying methods #join, #not, #where... try later
    start_date = Time.parse(date1)
    end_date = Time.parse(date2)
    self.listings.reject do |listing|
      listing.reservations.detect do |res|
        start_date <= res.checkout && end_date >= res.checkin
      end
    end
  end

  def self.highest_ratio_res_to_listings
    # same point about the querying as before...
    self.all.max do |nabe1, nabe2|
      ratio1 = nabe1.count_reservations
      ratio1 /= nabe1.listings.count.to_f unless ratio1.zero?

      ratio2 = nabe2.count_reservations
      ratio2 /= nabe2.listings.count.to_f unless ratio2.zero?

      ratio1 <=> ratio2
    end
  end

  def self.most_res
    # again...
    self.all.max do |nabe1, nabe2|
      res1 = nabe1.count_reservations
      res2 = nabe2.count_reservations
      res1 <=> res2
    end
  end
end
