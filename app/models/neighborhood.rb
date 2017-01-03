class Neighborhood < ActiveRecord::Base 
  belongs_to :city
  has_many :listings
  
  def neighborhood_openings(start_date, end_date)
    first_date = Date.parse(start_date)
    last_date = Date.parse(end_date)

    @available_listings = []

    listings.each do |listing|
      @available_listings << listing 
    end
    
    @available_listings.delete_if do |listing|
      listing.reservations.any? do |reservation|
        first_date.between?(reservation.checkin, reservation.checkout) || last_date.between?(reservation.checkin, reservation.checkout)
      end
    end
    @available_listings
  end

  def self.highest_ratio_res_to_listings
    neighborhood_ratios = {}
    self.all.each do |neighborhood|
      if neighborhood.listings.count > 0 
        counter = 0
        neighborhood.listings.each do |list|
          counter += list.reservations.count
        end
        neighborhood_ratios[neighborhood] = (counter)/(neighborhood.listings.count)
      end
    end
    neighborhood_ratios.key(neighborhood_ratios.values.sort.last)
  end

  def self.most_res
    neighborhood_count = {}
    self.all.each do |neighborhood|
      counter = 0
      neighborhood.listings.each do |list|
        counter += list.reservations.count
      end
      neighborhood_count[neighborhood] = counter
    end
    neighborhood_count.key(neighborhood_count.values.sort.last)
  end
end
