class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    all_listings_ids = Listing.all.collect{|listing| listing.id} #returns list of all listing_ids

    overlapping_listing_ids = Reservation.all.select{|reservation| (reservation.checkin..reservation.checkout).overlaps?(start_date.to_date..end_date.to_date)}.collect{|result| result.listing_id}.uniq{|result| result} #identities overlapping instances and returns their listing_ids

    desired_listing_ids = all_listings_ids - overlapping_listing_ids #excludes listing_ids that overlap from all listing_ids
    desired_listing_ids.collect{|listing_id| Listing.find(listing_id)}
  end

  def self.highest_ratio_res_to_listings
    all_neighborhood_ids = []
    neighborhood_id_highest_ratio = 0
    listings_by_neighborhood_id = Hash.new(0)
    count_of_listings_by_neighborhood_id = Hash.new(0)
    count_of_reservations_by_neighborhood_id = Hash.new(0)
    ratio_reservation_to_listings = Hash.new(0)

    all_neighborhood_ids = Neighborhood.all.collect{|neighborhood| neighborhood.id}

    all_neighborhood_ids.each do |neighborhood_id|
      listings_by_neighborhood_id[neighborhood_id] = Listing.where("neighborhood_id = ?",neighborhood_id)

      count_of_listings_by_neighborhood_id[neighborhood_id] = listings_by_neighborhood_id[neighborhood_id].count

      count_of_reservations_by_neighborhood_id[neighborhood_id] = listings_by_neighborhood_id[neighborhood_id].collect{|listing| Reservation.where("listing_id = ?",listing.id).count}.sum

      if count_of_listings_by_neighborhood_id[neighborhood_id] != 0
        ratio_reservation_to_listings[neighborhood_id] = count_of_reservations_by_neighborhood_id[neighborhood_id].to_f/count_of_listings_by_neighborhood_id[neighborhood_id].to_f
      end
    end
    neighborhood_id_highest_ratio = ratio_reservation_to_listings.max_by{|key,value| value}.first
    Neighborhood.find(neighborhood_id_highest_ratio)
  end

  def self.most_res
    all_neighborhood_ids = Neighborhood.all.collect{|neighborhood| neighborhood.id}
    count_of_reservations_by_neighborhood_id = Hash.new(0)
    listings_by_neighborhood_id = Hash.new(0)
    all_neighborhood_ids.each do |neighborhood_id|
      listings_by_neighborhood_id[neighborhood_id] = Listing.where("neighborhood_id = ?", neighborhood_id)
      count_of_reservations_by_neighborhood_id[neighborhood_id] = listings_by_neighborhood_id[neighborhood_id].collect{|listing| Reservation.where("listing_id = ?",listing.id).count}.sum
    end
    neighborhood_id_most_res = count_of_reservations_by_neighborhood_id.max_by{|key,value| value}.first
    Neighborhood.find_by_id(neighborhood_id_most_res)
  end

end
