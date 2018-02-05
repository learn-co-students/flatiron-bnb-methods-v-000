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

  before_save :create_host
  before_destroy :remove_host
  
  def create_host
    self.host.update(host: true)
  end

  def remove_host
    self.host.update(host: false) if self.host.listings.count == 1
  end

  def average_review_rating
    reviews.average(:rating)
  end
  
end
