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

  after_create :set_user_as_host
  before_destroy :remove_user_as_host, if: :has_no_more_listings?


  def average_review_rating
    all_ratings = reviews.collect { |review| review.rating }
    sum_of_ratings = all_ratings.inject { |sum, rating| sum + rating }
    average_rating = sum_of_ratings.to_f / all_ratings.count.to_f
  end

  private
    def set_user_as_host
      host.host = true
      host.save
    end

    def remove_user_as_host
      host.host = false
      host.save
    end

    def has_no_more_listings?
      host.listings.count == 1
  end
end
