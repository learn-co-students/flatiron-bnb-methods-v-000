class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    all_listings_ids = Listing.all.collect{|listing| listing.id} #returns list of all listing_ids

    overlapping_listing_ids = Reservation.all.select{|reservation| (reservation.checkin..reservation.checkout).overlaps?(start_date.to_date..end_date.to_date)}.collect{|result| result.listing_id}.uniq{|result| result} #identifies overlapping instances and returns their listing_ids

    desired_listing_ids = all_listings_ids - overlapping_listing_ids #excludes listing_ids that overlap from all listing_ids

    desired_listing_ids.collect{|listing_id| Listing.find(listing_id)} #returns listing instances that do not overlap
  end

  def self.highest_ratio_res_to_listings
    all_city_ids = City.all.collect{|city| city.id}.uniq{|city_id| city_id}
    count_of_listings_by_city_id = Hash.new(0)
    count_of_reservations_by_city_id = Hash.new(0)
    ratio_reservation_to_listings = Hash.new(0)
    listings_by_city_id = Hash.new(0)
    all_city_ids.each do |city_id|
      listings_by_city_id[city_id] = Listing.joins(:neighborhood).where("neighborhoods.city_id = ?",city_id)
      count_of_listings_by_city_id[city_id] = listings_by_city_id[city_id].count
      count_of_reservations_by_city_id[city_id] = listings_by_city_id[city_id].collect{|listing| Reservation.where("listing_id = ?",listing.id).count}.sum
      ratio_reservation_to_listings[city_id] = count_of_reservations_by_city_id[city_id]/count_of_listings_by_city_id[city_id]
    end
    city_id_highest_ratio = ratio_reservation_to_listings.max_by{|key,value| value}.first
    City.find_by_id(city_id_highest_ratio)
  end

  def self.most_res
    all_city_ids = City.all.collect{|city| city.id}.uniq{|city_id| city_id}
    count_of_reservations_by_city_id = Hash.new(0)
    listings_by_city_id = Hash.new(0)
    all_city_ids.each do |city_id|
      listings_by_city_id[city_id] = Listing.joins(:neighborhood).where("neighborhoods.city_id = ?",city_id)
      count_of_reservations_by_city_id[city_id] = listings_by_city_id[city_id].collect{|listing| Reservation.where("listing_id = ?",listing.id).count}.sum
    end
    city_id_most_res = count_of_reservations_by_city_id.max_by{|key,value| value}.first
    City.find_by_id(city_id_most_res)
  end

end
