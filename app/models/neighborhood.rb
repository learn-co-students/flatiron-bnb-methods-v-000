class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(date1, date2)
      first = Date.parse(date1)
      second = Date.parse(date2)
      open = []

      listings.each do |list|
        open << list
      end

      open.delete_if do |list|
        list.reservations.any? do |res|
          first.between?(res.checkin, res.checkout) ||
          second.between?(res.checkin, res.checkout)
        end
      end
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


    def self.most_res
      res = {}
      self.all.each do |city|
        counter = 0
        city.listings.each do |a|
          counter += a.reservations.count
        end
        res[city] = counter
      end
      res.key(res.values.sort.last)
    end




end
