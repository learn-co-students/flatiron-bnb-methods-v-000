class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings 

  def neighborhood_openings(start_date, end_date)
    openings = [] 
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    listings.each do |l| 
       openings << l if !l.reservations.any? {|reservation| reservation.checkin <= end_date && reservation.checkout >= start_date }
    end 
    openings 
  end 

  def self.highest_ratio_res_to_listings
    n = Neighborhood.all.sort_by do |neighborhood| 
    if neighborhood.reservations.count != 0 
      neighborhood.reservations.count.to_f / neighborhood.listings.count.to_f 
    else 
      0 
    end 
  end 
  
  highest = n.last 
    
end 


  def self.most_res 
    neighborhoods = self.all.sort_by { |neighborhood| neighborhood.reservations.count }.reverse
    most_res = neighborhoods.first
  end 
  
  
  

end
