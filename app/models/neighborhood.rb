class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(ckin, ckout)
    open_listings = []
    self.listings.each do |listing|
      if !res_conflicts?(listing, ckin, ckout)
        open_listings << listing
      end
    end
    open_listings
  end

  def res_conflicts?(listing, ckin, ckout)
    ckin = ckin.to_date
    ckout = ckout.to_date

    listing.reservations.each do |res|
      if res.checkout > ckin && res.checkout < ckin
        return true
      elsif res.checkin > ckin && res.checkin < ckin
        return true
      end
    end
    return false
  end

  # class methods

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
    self.find_by(name: self.res_counts.max_by {|k, v| v}[0])
  end

  # returns a hash with neighborhood names as keys and the number of reservations as values
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
end
