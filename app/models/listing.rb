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
  validate :neighborhood_exists

  before_save :define_host
  before_destroy :destroy_host

  def average_review_rating
    denominator = self.reviews.count
    numerator = self.reviews.inject(0){|sum,review| sum + review.rating}
    if denominator == 0
      "No ratings available."
    else
      numerator.to_f / denominator
    end
  end

private

  def neighborhood_exists
    errors.add(:neighborhood_id, "can't be blank") unless Neighborhood.exists?(neighborhood_id)
  end

  def define_host
    self.host.update(host: true)
  end

  def destroy_host
    self.host.update(host: false) if self.host.listings.count <= 1
  end
end
