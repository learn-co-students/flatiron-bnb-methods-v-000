class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  # Returns all of the available apartments in a neighborhood, given the date range
  def neighborhood_openings(start_date, end_date)
    open_listings = listings.collect {|l| l if l.reservations.count == 0}
    reservations.each do |r|
      booked_dates = r.checkin..r.checkout
      unless booked_dates === Date.parse(start_date) || booked_dates === Date.parse(end_date)
        open_listings << r.listing
      end
    end
    open_listings.uniq
  end

  def ratio_res_to_listings
    if listings.count > 0
      reservations.count.to_f / listings.count.to_f
    else
      0
    end
  end


  # Returns nabe with highest ratio of reservations to listings
  def self.highest_ratio_res_to_listings
    highest = self.first
    self.all.each do |neighborhood|
      if neighborhood.ratio_res_to_listings > highest.ratio_res_to_listings
        highest = neighborhood
      end
    end
    highest
  end

  # Returns nabe with most reservations
  def self.most_res
    most_reservations = self.first
    self.all.each do |neighborhood|
      if neighborhood.reservations.count > most_reservations.reservations.count
        most_reservations = neighborhood
      end
    end
    most_reservations
  end
  
end
