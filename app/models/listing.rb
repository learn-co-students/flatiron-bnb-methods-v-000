class Listing < ActiveRecord::Base
  # ActiveRecord Associations
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  # Validations
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  # Callbacks
  before_save :set_user_to_host
  before_destroy :set_user_to_guest

  def average_review_rating
    rating = 0
    self.reviews.each do |review|
      rating += review.rating
    end
    rating * 1.0 / self.reviews.length
  end

  private
  def set_user_to_host
    user = User.find_by(id: self.host)
    user.host = true
    user.save
  end

  def set_user_to_guest
    user = User.find_by(id: self.host)
    if user.listings.length == 1
      user.host = false
      user.save
    end
  end
end
