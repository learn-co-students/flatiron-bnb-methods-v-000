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
  before_create :set_host
  before_destroy :check_if_still_host

  def average_review_rating
    self.reviews.reduce(0) {|total, review| total += review.rating } / self.reviews.count.to_f
  end

  def set_host
    self.host.update(host: true)
  end

  def check_if_still_host
    self.host.update(host: false) if self.host.listings.count == 1
  end

end
