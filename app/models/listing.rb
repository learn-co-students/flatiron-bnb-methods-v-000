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

  after_save :set_host_status_to_true

  before_destroy :validate_host_status

  def has_conflict?(requested_in, requested_out)
    reserved_in_out = reservations.collect do |reservation|
      {checkin: reservation.checkin, checkout: reservation.checkout}
    end
    reserved_in_out = reserved_in_out.sort_by { |k| k[:checkin] }

    conflicts = reserved_in_out.any? do |hash|
      conflict?(hash, requested_in, requested_out)
    end

    conflicts
  end

  # helper method

  def conflict?(reservation_in_out, requested_in, requested_out)
    (reservation_in_out[:checkin] < requested_in && reservation_in_out[:checkout] > requested_in) || (reservation_in_out[:checkin] < requested_out && reservation_in_out[:checkout] > requested_out)
  end

  def average_review_rating
    ratings = reservations.collect{ |reservation| reservation.review.rating }
    ratings.sum.to_f / ratings.size
  end

  private

  def set_host_status_to_true
    host.host = true
    host.save
  end

  def validate_host_status
    if host.listings.size == 1 || host.listings.size == 0
      host.host = false
      host.save
    end
  end
end
