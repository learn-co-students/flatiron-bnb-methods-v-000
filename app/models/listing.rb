class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
 
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

   after_create :set_user_host_status
   after_destroy :remove_user_host_status

   
  

  def duration
  end

  def total_price
  end

  def average_review_rating
    self.reviews.average(:rating)
  end

  private

  def set_user_host_status
    self.host.host = true
    self.host.save
  end

  def remove_user_host_status
    self.host.host = false if self.host.listings.empty?
    self.host.save
  end

   
end
