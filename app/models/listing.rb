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

  before_save :make_user_into_host
  before_destroy :un_host_user_if_last_listing

  def average_review_rating
    stars = self.reviews.collect{|review| review.rating}
    if stars.size != 0
      average_rating = stars.sum.fdiv(stars.size)
    end
    average_rating
  end

  private

  def make_user_into_host
    user = User.find(self.host_id)
    user.update(host:true)
  end

  def un_host_user_if_last_listing
    user = User.find(self.host_id)
    if user.listings.size == 1
      user.update(host:false)
    end
  end

end
