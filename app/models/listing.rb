class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  after_create :make_host
  before_destroy :remove_host

  def average_review_rating
    total_rating = 0.0
    self.reviews.each { |rev| total_rating += rev.rating }
    total_rating / self.reviews.count
  end

  private

  def make_host
    user = self.host
    user.host = true
    user.save
  end

  def remove_host
    user = self.host
    user.host = false
    user.save unless user.listings.count > 1
  end
end
