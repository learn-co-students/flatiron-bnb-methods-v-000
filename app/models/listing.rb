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
  before_create :change_host_status, :unless => :host?
  after_destroy :change_host_to_guest, :if => :has_no_listings?

  def average_review_rating
    ratings = []
    self.reviews.each do |review|
      ratings << review.rating
    end
    ratings.sum.to_f/ratings.count
  end

private

  def host?
    User.find(host_id).host
  end

  def change_host_status
    user = User.find(host_id)
    user.host = true
    user.save
  end

  def has_no_listings?
    user = User.find(host_id).listings
    user == []
  end

  def change_host_to_guest
    user = User.find(host_id)
    user.host = false
    user.save
  end
end
