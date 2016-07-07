class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true


 # def self.available(checkin_date, checkout_date)
 #   if checkin_date && checkout_date
  #    joins(:reservations).where.not(reservations:{checkin: (checkin_date..checkout_date)}) & joins(:reservations).where.not(reservations:{checkout: (checkin_date..checkout_date)})
  #    else
   #   []
 #   end
#  end

  def self.available(checkin_date, checkout_date)
    if checkin_date && checkout_date
      r = Reservation.where(:checkin => checkin_date..checkout_date).pluck(:listing_id)
      r2 = Reservation.where(:checkout => checkin_date..checkout_date).pluck(:listing_id)
      where("id not in (?)", r+r2)
      else
      []
    end
  end

 # def self.most_listings
 #   binding.pry
  #  array = []
 #   Listing.joins(:reservations).each do |listing|
  #    array << listing.reservations.count
  #  end
   # joins(:reservations).where(.reservations.count = array.max)
 # end

#where not the argument checkin is between the reservations checkin and checkout

  private

  def host_status_change_to_true
    self.host.host = true
  end

  def host_status_change_to_false
    self.host.host = false 
  end

  end


  #Listing1 - Has a re 5/2-5/8 
  #5/1-5/5