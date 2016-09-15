class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(checkin, checkout)
    self.listings(created_at: checkin..checkout)
  end

   def self.res_counts
    res_count = {}
    self.all.each do |neighb|
      count = 0
      neighb.listings.each do |listing|
        count += listing.reservations.size
      end
      res_count[neighb.name] = count
    end
    res_count
  end

  def self.highest_ratio_res_to_listings
    ratios = {}
    self.res_counts.each do |name, num_res|
      num_listings = self.find_by(name: name).listings.size
      if num_listings == 0
        ratios[name] = 0
      else
        ratios[name] = num_res/num_listings
      end
    end
    self.find_by(name: ratios.max_by {|k,v| v}[0])
  end

  def self.most_res
    self.all.max do |a, b|
      a.reservations.length <=> b.reservations.length
    end
  end

end
