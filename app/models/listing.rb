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
  before_create :make_host
  before_destroy :remove_host

  def average_review_rating
    self.reviews.average(:rating)
  end

  private

  def make_host
    self.host.update(host: true)
  end

  def remove_host
    self.host.update(host: false) if self.host.listings.size == 1
  end

end
