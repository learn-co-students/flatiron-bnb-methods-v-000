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
  validates :neighborhood, presence: true

  def average_review_rating
    total_rating_points = 0

    if self.reviews != nil
      self.reviews.each do |review|
        total_rating_points = total_rating_points + review.rating
      end
    end

    total_rating_points.fdiv(self.reviews.size)
  end
end
