class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  before_create :make_host_true
  after_destroy :make_host_false

  def average_review_rating
    total = 0.0
    self.reviews.all.each do |review|
      total += review.rating
    end
    total / self.reviews.count
  end

  private

  def make_host_true
    self.host.host = true
    self.host.save
  end

  def make_host_false
    if self.host.listings.count == 0
      self.host.host = false
      self.host.save
    end
  end

end
