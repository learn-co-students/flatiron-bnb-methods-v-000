class Listing < ActiveRecord::Base
  before_create :change_host_status_to_true
  before_destroy :change_host_status_to_false_if_last_listing

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  scope :unavailable, ->(start_date, end_date) { joins(:reservations).where(
    'checkin <= ? AND checkout >= ?', end_date, start_date
    ).distinct }

  scope :available, ->(start_date, end_date) { all - unavailable(start_date, end_date) }

  def available?(checkin, checkout)
    reservations.contains_dates(checkin, checkout).blank?
  end

  def average_review_rating
    reviews.average('rating')
  end

  def change_host_status_to_true
    host.is_a_host
  end

  def change_host_status_to_false_if_last_listing
    return if host.listings.count > 1
    host.is_not_a_host
  end
end
