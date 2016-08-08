# Listings
class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, class_name: 'User'
  has_many :reservations
  has_many :reviews, through: :reservations
  has_many :guests, class_name: 'User', through: :reservations

  # Validations
  validates_presence_of :address, :listing_type, :title, :description, :price,
                        :neighborhood

  after_save :change_user_to_host
  before_destroy :change_host_to_user

  def change_user_to_host
    user = User.find(host_id)
    user.update(host: true)
  end

  def change_host_to_user
    user = User.find(host_id)
    user.update(host: false) if user.listings.size == 1
  end

  def average_review_rating
    reviews.average(:rating)
  end
end
