class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    openings = []
    parsed_start = Date.parse(start_date)
    parsed_end = Date.parse(end_date)
    listings.each do |listing|
      listing.reservations.each do |reservation|
        if reservation.status == "accepted" && reservation.checkin.between?(parsed_start, parsed_end) && reservation.checkout.between?(parsed_start, parsed_end)
          openings << listing
        end
      end
    end
  end

  def self.highest_ratio_res_to_listings

    listing_nb = []
    Listing.all.each do |listing|
      listing_nb << listing.neighborhood.name
    end

    uniq_nb = listing_nb.uniq

    res_nb = []
    Reservation.all.each do |reservation|
      if reservation.status == "accepted"
        res_nb << reservation.listing.neighborhood.name
      end  
    end  

    nb_hash = {}
    uniq_nb.each do |nb|
      nb_hash.merge!(nb => res_nb.select { |entry| entry == nb }.count)
    end

    answer = nb_hash.sort_by {|nb,num| num}.reverse.to_h.keys.first
    Neighborhood.find_by_name(answer)

  end

  def self.most_res

    res_nb = []
    Reservation.all.each do |reservation|
      if reservation.status == "accepted"
        res_nb << reservation.listing.neighborhood.name
      end
    end

    uniq_nb = res_nb.uniq

    nb_hash = {}
    uniq_nb.each do |nb|
      nb_hash.merge!(nb => res_nb.select { |entry| entry == nb }.count)
    end

    answer = nb_hash.sort_by {|nb,num| num}.reverse.to_h.keys.first
    Neighborhood.find_by_name(answer)

  end

end