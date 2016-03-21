class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  def average_review_rating
    total_ratings = 0
    # default return value is no ratings
    avg = "no ratings"
    self.reviews.each do |review|
      total_ratings += review.rating
    end
    if self.reviews.count > 0
      avg = total_ratings.to_f / self.reviews.count.to_f
    end
    avg
  end
  
  validates :address, presence: true 
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true
  
  after_save :add_host_status
  after_destroy :change_host_status
  
  
  private 
  
  def add_host_status 
    if self.host.host? == false
      self.host.host = true
      self.host.save
    end
  end
  
  def change_host_status
    if self.host.listings.empty?
      self.host.host = false 
      self.host.save
    end
  end
end
