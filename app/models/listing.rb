class Listing < ActiveRecord::Base
  after_create :change_host_status
  before_destroy :check_host_status

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

  def average_review_rating
    rating_count = 0.0
    reviews.each do |review|
      rating_count+= review.rating
    end
    (rating_count / reviews.count).to_f
  end

  private

  def change_host_status
    user = self.host
    user.update(host: true)
    user.save
  end

  def check_host_status
    user = self.host
    if user.listings.count == 1
      user.update host: false
      user.save
    end
  end

end
