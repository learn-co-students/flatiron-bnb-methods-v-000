class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  # return all of the open listings in a neighborhood within specific dates
  def neighborhood_openings(start, ending)
    open_listing = []
    self.listings.each do |listing|
      if listing.available?(start, ending)
        open_listing << listing
      end
    end
    open_listing
  end

  # Returns the neighborhood that has the highest amount of reservations per listing
  def self.highest_ratio_res_to_listings
    highest_neighborhood = nil # tracks the city with the highest ratio
    highest_ratio = 0

    # For each neighborhood, check each listing and add the number of reservations.
    self.all.each do |neighborhood|
      reservation_count = 0
      res_to_listing_ratio = 0

      neighborhood.listings.each do |listing|
        reservation_count = reservation_count + listing.reservations.count
      end

      unless neighborhood.listings.empty?
        # Using the total number of reservations for a neighborhood, find the ratio of reservations to listings
        res_to_listing_ratio = reservation_count / neighborhood.listings.count

        # If a neighborhood has a higher ratio than the current highest, it becomes the highest neighborhood.
        if res_to_listing_ratio > highest_ratio
          highest_neighborhood = neighborhood
          highest_ratio = res_to_listing_ratio
        end
      end
    end

    highest_neighborhood
  end

  # Returns the neighborhood with the most number of reservations.
  def self.most_res
    highest_neighborhood = nil # Tracks the neighborhood with the highest amount of reservations.
    highest_res_count = 0

    # For each neighborhood, check each listing and add the number of reservations to the total.
    self.all.each do |neighborhood|
      res_count = 0

      neighborhood.listings.each do |listing|
        res_count = res_count + listing.reservations.count
      end

      # if a cities total num of reservations is higher than the current highest city,
      # it becomes the new highest neighborhood.
      if res_count > highest_res_count
        highest_res_count = res_count
        highest_neighborhood = neighborhood
      end
    end

    highest_neighborhood
  end

end
