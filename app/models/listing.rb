class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, class_name: 'User'
  has_many :reservations
  has_many :reviews, through: :reservations
  has_many :guests, class_name: 'User', through: :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  before_create :make_host
  after_destroy :remove_host

  def average_review_rating
    reviews.average(:rating).to_f
  end

  private

  def make_host
    host.update(host: true)
  end

  def remove_host
    host.update(host: false) if host.listings.empty?
  end
end
