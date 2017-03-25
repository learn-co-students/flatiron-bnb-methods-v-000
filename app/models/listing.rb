class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  before_create :user_becomes_host

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  before_destroy :host_becomes_user

  def user_becomes_host
    self.host.host = true
    self.host.save
  end

  def host_becomes_user
    if self.host.listings.length == 1
      self.host.host = false
      self.host.save
    end
  end

  def average_review_rating
    ratings = self.reviews.collect do |review|
      review.rating
    end
    sum = 0.0
    ratings.each {|rating| sum += rating}
    sum/ratings.length
  end

end
