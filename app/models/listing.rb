class Listing < ActiveRecord::Base
  validates :title, presence: true
  validates :listing_type, presence: true
  validates :price, presence: true
  validates :address, presence: true
  validates :description, presence: true
  validates :neighborhood_id, presence: true
  after_save :set_user_to_host
  after_destroy :set_host_to_user
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  def set_user_to_host
    self.host.update(host: true)
  end

  def set_host_to_user
    self.host.update(host: false) if self.host.listings.none?
  end

  def average_review_rating
    self.reviews.inject(0){|sum, n| sum += n.rating} / self.reviews.count.to_f
  end
  
end
