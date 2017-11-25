class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  

  def guests
    User.all.select{|user| !user.host}
  end

  def hosts
    User.all.select{|user| user.host}
  end

  def host_reviews
    reviews = Array.new.tap{|review| self.reservations.each{|res| review << Review.find_by(guest_id: res.guest_id)}}
  end
end
