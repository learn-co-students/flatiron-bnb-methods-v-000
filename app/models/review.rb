class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating,      presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate  :reservation_status
  validate  :checkout_date

  # returns the average review rating for this collection of reviews.
  def self.average_rating(reviews)
    average_review = 0.0
    review_count = reviews.size
    if review_count > 0
      rating_total = reviews.inject(0) { |sum_rating, review| sum_rating + review.rating }
      average_review = rating_total.to_f / review_count.to_f
    end
    average_review
  end

private

  def checkout_date
    if reservation.nil? || reservation.checkout >= Date.today
      errors.add(:reservation, "checkout must be yesterday or earlier")
    end
  end

  def reservation_status
    if reservation.nil? || reservation.status != "accepted"
      errors.add(:reservation, "must be accepted")
    end
  end
end
