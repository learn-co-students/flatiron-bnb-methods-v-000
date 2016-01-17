class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    s_date = Date.parse(start_date)
    e_date = Date.parse(end_date)
    @openings = []
    listings.each do |a|
      @openings << a
    end
    @openings.delete_if do |a|
      a.reservations.any? do |b|
        s_date.between?(b.checkin, b.checkout) ||
        e_date.between?(b.checkin, b.checkout)
      end
    end
  end

  def self.highest_ratio_res_to_listings
    ratios = {}
    self.all.each do |city|
      counter = 0
      city.listings.each do |a|
        counter += a.reservations.count
      end
      ratios[city] = (counter)/(city.listings.count)
    end
    ratios.key(ratios.values.sort.last)
  end

  def self.most_res
    most = {}
    self.all.each do |city|
      counter = 0
      city.listings.each do |a|
        counter += a.reservations.count
      end
      most[city] = counter
    end
    most.key(most.values.sort.last)
  end

end