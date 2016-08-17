class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings



  def city_openings(d1, d2)
    listings.each do |l|
      l.reservations.each do |r|
        d1.to_date > r.checkout && d2.to_date < r.checkin
      end
    end
  end


   def self.highest_ratio_res_to_listings
    ratio = Hash.new
    City.all.each do |c|
     ratio[c] = c.reservations.count/c.listings.count
    end
    ratio.max_by{|k,v| v}.first
   end

   def self.most_res
     City.all.sort do |a,b|
       a.reservations.count <=> b.reservations.count
     end.last
   end

end
