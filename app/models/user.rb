class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  #before_save :change_host_status_back

  private

  #def change_host_status_back
#    self.host = false if !self.listings.any?
#  end
end
