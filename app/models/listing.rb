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

  after_create :set_user_host
  after_destroy :set_user_false

  def average_review_rating
    reviews = self.reservations.collect do |res|
      res.review.rating
    end
    reviews.sum.to_f / reviews.size
  end

  private

  def set_user_host
    User.find(self.host_id).update(host: true)
  end

  def set_user_false
    User.find(self.host_id).update(host: false) if User.find(self.host_id).listings.empty?
  end

end
