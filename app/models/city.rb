class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  def city_openings(startdate, enddate)
    availables = []
    self.listings.each do |listing| 
      if listing.reservations.empty?
        availables << listing
      else
        listing.reservations.each do |reservation|
          if reservation.checkin >= enddate.to_datetime || reservation.checkout <= startdate.to_datetime
            availables << reservation.listing
          end
        end
      end
    end
    availables
   end

  def self.highest_ratio_res_to_listings
        self.all.max_by do |place| 
          if place.listings.count == 0
            0
          else
            place.listings.map{|l| l.reservations.count}.sum / place.listings.count
          end
        end
      end

  def self.most_res
    self.all.max_by {|place| place.listings.map {|listing| listing.reservations.count}}
  end



end

