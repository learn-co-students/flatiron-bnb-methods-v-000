class Listing < ActiveRecord::Base
  belongs_to :neighborhood, required: true #associated with neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :description, presence: true
  validates :listing_type, presence: true
  validates :price, presence: true
  validates :title, presence: true
  validates :neighborhood_id, presence: true

  before_save :change_user_to_host
  before_destroy :change_host_to_user

  def average_review_rating
    count = 0
    @total_ratings = 0.0

    reviews.each do |review|
      count = count += 1
      @total_ratings += review.rating
    end
    (@total_ratings / count)
  end

  private

  def change_user_to_host
    user = self.host
    user.update(host: true)
    user.save
  end

  def change_host_to_user
    user = self.host
    if user.listings.count == 1
      user.update(host: false)
      user.save
    end
  end

end
