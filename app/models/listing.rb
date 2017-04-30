class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :title, presence: true
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  after_save :flag_user_as_host
  before_destroy :clear_user_host_flag

  def available?(start_date, end_date)
    reservations.all? do |reservation|
      reservation.checkin > end_date ||
        reservation.checkout < start_date
    end
  end

  def average_review_rating
    sum_of_ratings = reviews.all.collect(&:rating).sum
    sum_of_ratings.to_f / reviews.all.count
  end

  private

  def flag_user_as_host
    host.host = true unless host.nil?
    host.save
  end

  def clear_user_host_flag
    host.host = false unless host.nil? || host.listings.count > 1
    host.save
  end
end
