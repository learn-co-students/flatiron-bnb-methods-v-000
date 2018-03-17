class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    self.listings.each do |l|
      l.reservations.collect do |r|
        if r.checkin == start_date && r.checkout ==end_dated
          l
        end
      end
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by {|city| city.total_res/city.listings.count}
  end

  def self.most_res
    self.all.max_by {|city| city.total_res}
  end

  def total_res
    @total = 0
    self.listings.each do |l|
      @total += l.reservations.count
    end
    @total
  end

end
