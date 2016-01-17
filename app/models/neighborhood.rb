class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(date1, date2)
    a = Date.parse(date1)
    b = Date.parse(date2)
    availables = []
    listings.each do |list|
      availables << list
    end
    availables.delete_if do |list|
      list.reservations.any? do |res|
        a.between?(res.checkin, res.checkout) ||
        b.between?(res.checkin, res.checkout)
      end
    end
  end

  def self.highest_ratio_res_to_listings
    ratios = {}
    self.all.each do |neigh|
      if neigh.listings.count > 0
        counter = 0
        neigh.listings.each do |list|
          counter += list.reservations.count
        end
        ratios[neigh] = counter/neigh.listings.count
      end
    end
    ratios.key(ratios.values.sort.last)
  end

  def self.most_res
    most = {}
    self.all.each do |neigh|
      counter = 0
      neigh.listings.each do |list|
        counter += list.reservations.count
      end
      most[neigh] = counter
    end
    most.key(most.values.sort.last)
  end

end
