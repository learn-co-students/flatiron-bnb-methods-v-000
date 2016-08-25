class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_create :set_host_to_true
  before_destroy :set_host_to_false

  def set_host_to_true
    self.host.host = true
    self.host.save
  end

  def set_host_to_false
    if self.host.listings.size < 2
      self.host.host = false
      self.host.save
    end
  end

  def average_review_rating
    self.reviews.inject{ |sum, review| sum.rating + review.rating }.to_f / self.reviews.size
  end

end
