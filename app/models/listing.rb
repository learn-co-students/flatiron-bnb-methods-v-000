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
  before_destroy :remove_host_status_from_user


  def average_review_rating
    ratings = self.reviews.map do |review|
      review.rating
    end
    ratings.sum.fdiv(ratings.count)
  end

  private 

  def make_user_host
    user = User.find(self.host_id)
    user.update(host: true)
  end

  def remove_host_status_from_user
    user = User.find(self.host_id)
    if user.listings.size == 1
      user.update(host: false)
    end
  end

end
