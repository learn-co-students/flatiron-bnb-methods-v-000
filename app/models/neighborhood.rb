class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings



  def neighborhood_openings(date1, date2)
    date1 = Date.parse(date1)
    date2 = Date.parse(date2)
    listings.select do |list|
      list if list.reservations.all? { |res| res.checkout <= date1 || res.checkin >= date2 }
    end
  end


  def ratio_reservations_to_listings
    if listings.count > 0 && reservations.count > 0
      reservations.count.to_f / listings.count.to_f
    else
      return 0
    end
  end

  def self.highest_ratio_res_to_listings
    all.max do |a, b|
      a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
    end
  end

  def self.most_res
    all.max do |a, b|
      a.reservations.count <=> b.reservations.count
    end
  end

end
