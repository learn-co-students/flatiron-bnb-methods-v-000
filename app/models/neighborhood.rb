require 'pry'
class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings


def neighborhood_openings(opening, closing) 
    checkin_date = Date.parse(opening)
    checkout_date = Date.parse(closing)
    @array = []

    listings.each do |list|
      @array << list unless list.reservations.any? { |reservation| 
        reservation.checkin.between?(checkin_date, checkout_date) || reservation.checkout.between?(checkin_date, checkout_date)
      }
    end 
    @array
  end 

  def self.highest_ratio_res_to_listings
    ratio = {}

    self.all.each do |neighborhood|
      if neighborhood.listings.count > 0 
      counter = 0
      neighborhood.listings.each do |x|
        counter += x.reservations.count 
      end 
      ratio[neighborhood] = counter / neighborhood.listings.count 
    end
  end
      ratio.key(ratio.values.sort.last)
    end 

  def self.most_res
    most_res = {}

    self.all.each do |neighborhood|
      counter = 0
      neighborhood.listings.each do |x|
        counter += x.reservations.count 
      end 
      most_res[neighborhood] = counter 
    end
    most_res.key(most_res.values.sort.last)
  
  end 



end #ends class
