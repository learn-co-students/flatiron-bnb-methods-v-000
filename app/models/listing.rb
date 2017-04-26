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

  before_create :set_host_true
  before_destroy :set_host_false

  def average_review_rating
    revtotal = 0
    reviews.each do |review|
      revtotal = revtotal + review.rating.to_f
    end
    revtotal / reviews.count
  end

  private

  def set_host_true
    self.host.host = true
    self.host.save
  end

  def set_host_false
    if self.host.listings.count == 1
      self.host.host = false
      self.host.save
    end
  end
end
