class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def num_listings
    listings.length
  end

  def num_reservations
    n=0.0
    listings.each do |l|
      n+=l.reservations.length
    end
    n
  end

  def ratio
    num_reservations/num_listings
  end
  
  def neighborhood_openings(date1,date2)
    date1=date1.to_date
    date2=date2.to_date
    r=[]
    listings.each do |listing|
      included=true
      listing.reservations.each do |res|
        if res.status=="accepted"
          if res.checkin<=date1 and date1<=res.checkout then included=false end
          if res.checkin<=date2 and date2<=res.checkout then included=false end
          if res.checkin>=date1 and date2>=res.checkout then included=false end
        end
      end
      if included then r<<listing end
    end
    r
  end
  
  def self.highest_ratio_res_to_listings
    highest_rat=0.0
    m=nil
    all.each do |n|
      if n.ratio>highest_rat
        m=n
        highest_rat=n.ratio
      end
    end
    m
  end

    def self.most_res
    highest_res=0
    m=nil
    all.each do |n|
      if n.num_reservations>highest_res
        m=n
        highest_res=n.num_reservations
      end
    end
    m
  end

end
