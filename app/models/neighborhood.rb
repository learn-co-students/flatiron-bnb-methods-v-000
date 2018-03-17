class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(arrive, depart)
    dates = arrive..depart
    self.listings.select {|listing| (((listing.reservations) & dates.to_a).empty?)}
    end

  def self.highest_ratio_res_to_listings
    res_by_city = []
    list_by_city = []
    ratios = {}

    Reservation.all.each do |res|
      list = Neighborhood.find_by_id(Listing.find_by_id(res.listing_id).neighborhood_id)
         res_by_city << list.name
       end

    Listing.all.each do |list|
      n = Neighborhood.find_by_id(list.neighborhood_id)
      list_by_city << n.name
    end

    Neighborhood.all.each do |n|
      nlist = []
      nrez = []

      list_by_city.each do |list|
        if list == n.name
          nlist << list
        end
      end

        res_by_city.each do |res|
          if res == n.name
            nrez << res
          end
        end

        if nrez.length > 0 && nlist.length > 0
          total =  nrez.length / nlist.length
          ratios[n.name] = total
        else
          ratios[n.name] = 0
        end
      end

      winner = ratios.max_by { |k, v| v }
      Neighborhood.find_by(name: winner[0])
    end

  def self.most_res
    arr = []
    Reservation.all.each do |reservation|
      listing = Listing.find_by_id(reservation.listing_id)
      neighborhood = Neighborhood.find_by_id(listing.neighborhood_id)
      arr << neighborhood
    end

    freq = arr.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    arr.max_by { |v| freq[v] }
  end

end
