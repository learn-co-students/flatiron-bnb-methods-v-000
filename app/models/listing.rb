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

  after_validation :set_host
  after_destroy :unset_host

  def average_review_rating
    reviews.average("rating").to_f
  end

  def self.available(start_date, end_date)
    joins(:reservations).where.not(
      reservations: {checkin: start_date..end_date}) &
    joins(:reservations).where.not(
      reservations: {checkout: start_date..end_date})
  end

  private
  def set_host
    host.update(host: true) if host
  end

  def unset_host
    host.update(host: false) unless host.listings.any?
  end
end
