class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(date_1, date_2)

    checkin_date = Date.parse(date_1)
    checkout_date = Date.parse(date_2)

    openings = []
    reservations.each do |res|

      blocked = (res.checkin.between?(checkin_date, checkout_date) || res.checkout.between?(checkin_date, checkout_date))
      if !blocked
        openings << res.listing
      end
    end
    openings
  end



  def self.highest_ratio_res_to_listings

    highest_ratio = 0
    popular_listing = ""


      Neighborhood.all.each do |n|
        list = n.listings.count
        res = n.reservations.count
        if list != 0
        ratio = res / list

        if ratio > highest_ratio
          highest_ratio = ratio
          popular_listing = n
        end
      end
    end
      popular_listing
    end


  def self.most_res

    most_res = 0
    popular_neighborhood = ""

    Neighborhood.all.each do |n|
      res = n.reservations.count
      if res > most_res
          most_res = res
          popular_neighborhood = n
      end
    end
      popular_neighborhood
  end

end
