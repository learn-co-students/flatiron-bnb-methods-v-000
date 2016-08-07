class Neighborhood < ActiveRecord::Base

  belongs_to :city

  has_many :listings
  has_many :reservations, through: :listings

  include Reservable

  def neighborhood_openings(start_date, end_date)
    openings(start_date, end_date)
  end



  # belongs_to :city
  # has_many :listings
  #
  # def neighborhood_openings(start, finish)
  #   Listing.where(neighborhood_id: self.id).collect do |listing|
  #     if listing.reservations.any? do |reservation|
  #         (reservation.check_in...reservation.check_out).overlaps?(start...finish)
  #       end
  #       nil
  #     else
  #       listing
  #     end
  #   end
  # end
  #
  # def self.highest_ratio_res_to_listings
  #   max = 0
  #   max_res = 0
  #   @save_res_neigh= nil
  #   save = nil
  #   Neighborhood.all.each do |neighborhood|
  #     listings = Listing.where(neighborhood_id: neighborhood.id)
  #     reservation_count = 0
  #     listings.each do |listing|
  #       reservation_count += listing.reservations.count
  #     end
  #     if reservation_count > max_res
  #       max_res = reservation_count
  #       @save_res_neigh = neighborhood
  #     end
  #     ratio = reservation_count.to_f/listings.count
  #     if ratio > max
  #       max = ratio
  #       save = neighborhood
  #     end
  #   end
  #   save
  # end
  #
  # def self.most_res
  #   highest_ratio_res_to_listings
  #   @save_res_neigh
  # end

end
