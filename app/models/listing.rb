class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, presence: true 
  validates :listing_type, presence: true 
  validates :title, presence: true 
  validates :description, presence: true 
  validates :price, presence: true 
  validates :neighborhood_id, presence: true 

  before_create :set_true 
  before_destroy :set_false 

  def set_true 
    self.host.host = true
    self.host.save
  end 

  def set_false 
    if self.host.listings.count == 1
      self.host.host = false
      self.host.save
    end
  end 

  def average_review_rating 
    total = 0 
    reviews.each do |review| 
      total = total + review.rating.to_f 
    end 
    total/reviews.count
  end 
  
  



  
end
