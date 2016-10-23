class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  after_save :set_user_to_host

  before_destroy :user_is_no_longer_host

  def average_review_rating
    reviews.average(:rating)
  end 

  private

  def set_user_to_host
    self.host.update(:host => true)
    #host is a method that listing can access, listing
    #cannot access a .user method so that is why we call
    #self.host and then set the host boolean in the user
    #migration to true
  end 

  def user_is_no_longer_host
    if self.host.listings.count == 1
      self.host.update(:host => false)
    end 
  end 

end
