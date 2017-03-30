class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(date1, date2)
    arr = []
    range = Date.parse(date1)..Date.parse(date2)

    self.listings.each do |listing|
      arr << listing
    end

    self.listings.each do |l|
      l.reservations.each do |r|
        if range.cover?(r.checkin) || range.cover?(r.checkout)
          arr.delete(l)
        end
      end
    end
    arr
  end

  def self.highest_ratio_res_to_listings
    self.all.max do |a, b|
      a_neighb = a.reservations.count
      b_neighb = b.reservations.count

      (a_neighb/a.listings.count rescue 0) <=> (b_neighb/b.listings.count rescue 0)
    end
  end

  def self.most_res
    self.all.max do |a_neighb, b_neighb|
      a_neighb.reservations.count <=> b_neighb.reservations.count
    end
  end


end
