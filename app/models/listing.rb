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

  after_create :make_user_host
  after_destroy :update_user_host_status

  def average_review_rating
    rating_sum = 0
    self.reviews.all.each do |review|
      rating_sum += review.rating
    end
    rating_sum.to_f/self.reviews.count.to_f
  end

  private

  def make_user_host
    self.host.update(host: true)
  end

  def update_user_host_status
    self.host.update(host: false) if self.host.listings.count == 0
  end

end
