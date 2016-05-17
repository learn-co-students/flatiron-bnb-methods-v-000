class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings, :foreign_key => "guest_id"
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, :class_name => "User", :through => :reservations, as: :host
  has_many :hosts, :class_name => "User", through: :trips, :source => "listing", :foreign_key => "host_id" 

  def host_reviews
    reviews = self.reservations.all.includes(:review)
    reviews.collect do |rezzy|
      rezzy.review
    end


  end
 
  
end
