class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

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

end
