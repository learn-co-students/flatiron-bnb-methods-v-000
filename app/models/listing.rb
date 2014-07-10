class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  has_many :reviews

  # Finds the average rating for a listing
  def average_rating
    ratings = []
    self.reviews.each do |review|
      ratings << review.rating
    end
  end

end
