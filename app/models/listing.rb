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

  after_save :change_user_to_host
  before_destroy :change_host_to_user

  def change_user_to_host
    user = User.find(self.host_id)
    user.update(host: true)
  end

  def change_host_to_user
    user = User.find(self.host_id)
    if user.listings.size == 1
      user.update(host: false)
    end
  end

  def average_review_rating
    reviews.average(:rating)
  end
end
