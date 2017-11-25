class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings


  def self.most_res
    #Neighborhood.find(Listing.joins(:reservations).group(:neighborhood_id).order(neighborhood_id: :asc).last.neighborhood_id)
    hood = 0
    number = 0
    Neighborhood.all.each do |x|
      if x.reservations.count > number
        hood = x.id
        number = x.reservations.count
      end
    end
    Neighborhood.find(hood)

  end

  def self.highest_ratio_res_to_listings
    hoods = Neighborhood.all.includes(:reservations, :listings)
    cid = 0
    ratio = 0
    hoods.all.each do |x|
      if x.reservations.count.to_f / x.listings.count.to_f > ratio
        ratio = x.reservations.count.to_f / x.listings.count.to_f
        cid = x.id
      end
    end
    Neighborhood.find(cid)
  end


   def neighborhood_openings(checkin, checkout)
    chkin = Date.parse(checkin)
    chkout = Date.parse(checkout)
    listings = []
    self.reservations.each do |x|
      listings<<Listing.find(x.listing_id) if !chkin.between?(x.checkin, x.checkout) && !chkout.between?(x.checkin, x.checkout)
      
    end
    listings
  end

end
