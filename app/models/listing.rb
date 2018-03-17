class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates_presence_of :address,:title,:description,:price, :neighborhood_id, :listing_type
  
  before_create :user_to_host
  before_destroy :host_to_user
  
  def user_to_host
    @user = self.host
    @user.host = true
    @user.save
  end
  
  def host_to_user
    @user = self.host
    if @user.listings.count < 2
      @user.host = false
      @user.save
    end
  end
  
  def average_review_rating
    total_review_points = 0
    self.reviews.each do |review|
      total_review_points += review.rating
    end
    total_reviews = self.reviews.count
    total_review_points.to_f/total_reviews
  end
  
end
