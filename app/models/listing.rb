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

  before_save :make_user_host
  before_destroy :unmake_user_host

  def average_review_rating
    rating = self.reviews.collect{|review| review.rating}
    if rating.size > 0
      average_rating = rating.sum.fdiv(rating.size)
    end
    average_rating
  end

  private

  def make_user_host
    user = User.find(self.host_id)
    user.update(host: true)
  end

  def unmake_user_host
    user = User.find(self.host_id)
    if user.listings.size == 1
      user.update(host: false)
    end
  end

end
