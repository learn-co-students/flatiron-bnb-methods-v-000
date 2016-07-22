require 'pry'
class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(date1, date2)
    availables = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        if reservation.checkin > date2.to_datetime || reservation.checkout < date1.to_datetime
          availables << reservation.listing
        end
      end
    end
    availables
  end
class << self
  def highest_ratio_res_to_listings
    @last_neighborhood = ""
    @last_ratio = 0.00
    self.all.each do |neighborhood|
      current_ratio = neighborhood.reservations.count.to_f/neighborhood.listings.count.to_f
      if current_ratio >= @last_ratio
        @last_neighborhood = neighborhood
        @last_ratio = current_ratio
      else 
        @last_neighborhood
        @last_ratio
      end
    end
    @last_neighborhood
  end

  def most_res
    neighborhoods = self.all
    neighborhoods.detect do |neighborhood|
      neighborhoods.all? {|test| neighborhood.reservations.count >= test.reservations.count}
    end
  end
end
end
