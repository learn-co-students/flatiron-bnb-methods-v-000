class Listing < ActiveRecord::Base
  validates :address, :title, :listing_type, :description, :price, :neighborhood, presence: true
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  after_create :true_host
  before_destroy :false_host

  def true_host
    user = self.host
    user.host = true
    user.save
  end

  def false_host
    user = self.host
    user.host = false
    user.save unless user.listings.count > 1
  end

  def average_review_rating
    my_rating = 0.0

    self.reviews.each do |review|
      my_rating += review.rating
    end
    my_rating / self.reviews.count
  end


end
