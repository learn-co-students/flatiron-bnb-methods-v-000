class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings



  def neighborhood_openings(start_date, end_date)

    if start_date.class == Date
       begin_date = start_date
     else
       begin_date = DateTime.strptime(start_date, "%Y-%m-%d")
    end

    if end_date.class == Date
      date_end = end_date
    else
      date_end = DateTime.strptime(end_date, "%Y-%m-%d")
    end

    search_range = (begin_date .. date_end)
    neighborhood_openings = []

    self.listings.each do |listing|
      checkins = []
      checkouts = []
      listing.reservations.each do |reservation|
        checkins << reservation.checkin
        checkouts << reservation.checkout
      end
      neighborhood_openings << listing if !search_range.overlaps?(checkins.sort.first .. checkouts.sort.last)
    end
    neighborhood_openings
  end

  def self.highest_ratio_res_to_listings
    neighborhood_ratio = 0.0
    highest_ratio_res_to_listings = nil

    Neighborhood.all.each do |neighborhood|
      if neighborhood_ratio < neighborhood.reservations_count/neighborhood.listings.count.to_f
        neighborhood_ratio = neighborhood.reservations_count/neighborhood.listings.count.to_f
        highest_ratio_res_to_listings = neighborhood
      end
    end
    highest_ratio_res_to_listings
  end


  def self.most_res

    reservations = 0
    most_res = nil
    Neighborhood.all.each do |neighborhood|
      if reservations < neighborhood.reservations_count
        reservations = neighborhood.reservations_count
        most_res = neighborhood
      end

    end
    most_res
  end



  def reservations_count
    neighborhood_reservations = 0
    self.listings.each do |listing|
      neighborhood_reservations += listing.reservations.count
    end
    neighborhood_reservations
  end

end
