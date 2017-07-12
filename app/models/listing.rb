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

  before_create :make_user_host
  before_destroy :make_user_nonhost

  def average_review_rating
    reviews_count = 0
    stars_count = 0
    self.reviews.each do |r|
      reviews_count += 1
      stars_count += r.rating
    end
    stars_count.to_f / reviews_count
  end

  private

  def make_user_host
    self.host.host = true
    self.host.save
  end

  def make_user_nonhost
    if self.host.listings.length == 1
      self.host.host = false
      self.host.save
    end
  end

end
