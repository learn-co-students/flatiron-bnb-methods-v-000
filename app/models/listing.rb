class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id


   def available(start, fin)
    dates=(Date.parse(start)..Date.parse(fin))
    self.reservations.none?{|r| dates.overlaps?(r.checkin..r.checkout)}
  end

end
