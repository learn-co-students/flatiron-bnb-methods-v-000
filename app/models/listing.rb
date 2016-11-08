class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id
  
  # before_create :user_to_host
  
  # def user_to_host
  #   self.host.update(host: true)
  #   # user = User.find(self.host.id)
  #   # user.host = true
  #   # user.save
  # end
end
