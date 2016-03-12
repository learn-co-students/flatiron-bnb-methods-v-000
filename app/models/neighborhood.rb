class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  # Searches through the neighborhoods's listings for open listings. 
  # Accepts a starting date and ending date.
  # A listing is considered open if it has no reservations that overlap those dates. 
  def neighborhood_openings(start_date, end_date)
    start_date, end_date = Date.parse(start_date), Date.parse(end_date)
    neighborhood_listings = self.listings
    open_listings = []

    # For each listing:
    #   Find all the non blocking reservations where checkin is after the end date OR checkout is before the start date.
    #   Compare the count of the listing's non blocking reservations with all its total reservations.
    #   If the counts match, that means the listing is available during the specific time period.
    #   Push those listings into the open_listings array for return
    neighborhood_listings.each do |listing|
      blocking_reservations =  listing.reservations.where("checkout > ? AND checkin < ?", start_date, end_date)
      open_listings << listing if blocking_reservations.count == 0
    end

    open_listings
  end

  # Searches through all neighborhoods and calculates their reservations to listings ratio.
  # Returns the neighborhood which has the highest ratio.
  def self.highest_ratio_res_to_listings
    neighborhoods = Neighborhood.all
    highest_ratio = 0.0
    neighborhood_with_highest_ratio = nil

    # Loop through each neighborhood to find the highest reservations to listings ratio. 
    neighborhoods.each do |neighborhood|
      listings_count = neighborhood.listings.count
      res_count = neighborhood.listings.joins(:reservations).count

      neighborhood_ratio = res_count.to_f / listings_count

      # Reassign highest_ratio and neighborhood_with_highest_ratio
      if neighborhood_ratio > highest_ratio
        highest_ratio = neighborhood_ratio
        neighborhood_with_highest_ratio = neighborhood
      end
    end

    neighborhood_with_highest_ratio
  end

  # Searches through all neighborhoods and finds the count of all reservations in the neighborhood's listings.
  # Returns the neighborhood with the highest reservations count.
  def self.most_res
    neighborhoods = Neighborhood.all
    highest_res_count = 0
    neighborhood_with_most_res = nil

    # Loop through each neighborhood and find neighborhood with the highest number of reservations.
    neighborhoods.each do |neighborhood|
      neighborhood_res_count = neighborhood.listings.joins(:reservations).count

      # Reassign highest_res_count and neighborhood_with_most_res
      if neighborhood_res_count > highest_res_count
        highest_res_count = neighborhood_res_count
        neighborhood_with_most_res = neighborhood
      end 
    end

    neighborhood_with_most_res
  end

end
