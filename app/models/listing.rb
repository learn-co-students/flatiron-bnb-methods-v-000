class Listing < ActiveRecord::Base
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true
  
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  before_save :change_host_status
  before_destroy :lose_host_status
  
  
  def average_review_rating
    sum = 0
    self.reviews.each do |review|
      sum += review.rating
    end
    sum.to_f / self.reviews.count
  end
  
  def change_host_status
    self.host.host = true
    self.host.save
  end 
  
  def lose_host_status
    self.host.host = false if self.host.listings.count == 1
    self.host.save
  end
  
  def is_available?(t1,t2)
    return true if self.reservations.where(checkin: t1.to_time..t2.to_time).empty? && self.reservations.where(checkout: t1.to_time..t2.to_time).empty? 
    return false
  end 
  
end
