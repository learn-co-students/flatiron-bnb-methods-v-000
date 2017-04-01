class User < ActiveRecord::Base

  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation" if self.host == true
  has_many :reviews, :foreign_key => 'guest_id' if self.host == true

  def host_reviews

  end

end
