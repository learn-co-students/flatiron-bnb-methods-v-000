class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  

  def city_openings(start_date, end_date)
    # listing = Listing.where(:created_at => start_date..end_date)
    checkin_date = Date.parse(start_date)
    checkout_date = Date.parse(end_date)
    @available_listings = []
    listings.each do |list|
      @available_listings << list unless list.reservations.any? {|reservation|
        reservation.checkin.between?(checkin_date, checkout_date) || reservation.checkout.between?(checkout_date, checkout_date)}
      end
      @available_listings
  end


  # Return the City that is "most full". What that means is it has the highest amount of reservations per listing.
  def self.highest_ratio_res_to_listings
    ratio = {}

    self.all.each do |city|
      if city.listings.count > 0 
      counter = 0
      city.listings.each do |listing|
        counter += listing.reservations.count 
      end 
      ratio[city] = counter / city.listings.count 
    end
  end
  ratio.key(ratio.values.sort.last)
  end 

  # Return the City with the most total number of reservations, no matter if they are all on one listing or otherwise.

  def self.most_res
    most_reservations = {}

    self.all.each do |city|
      if city.listings.count > 0
      counter = 0
      city.listings.each do |listing|
        counter += listing.reservations.count
      end
      most_reservations[city] = counter / city.listings.count
    end
  end
  most_reservations.key(most_reservations.values.sort.last)
  end

end

