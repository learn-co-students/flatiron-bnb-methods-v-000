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
  before_save :make_user_host
  after_destroy :no_longer_host

  def available?(checkin, checkout)
    self.reservations.where("checkin < ? AND checkout > ? AND listing_id != ?", checkout, checkin, id || 0).empty?
  end

  def make_user_host
    user = self.host
    user.host = true
    user.save
  end

  def no_longer_host
    user = self.host
    if user.listings.empty?
      user.host = false
      user.save
    end
  end

  def average_review_rating
    self.reviews.average(:rating)
  end
  
end
