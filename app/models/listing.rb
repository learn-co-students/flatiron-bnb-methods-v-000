class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true
  before_create :user_to_host
  after_destroy :check_if_host

  def average_review_rating
    self.reviews.average(:rating)
  end

  private

  def user_to_host
    self.host.update(host: true)
  end

  def check_if_host
    if self.host.listings.empty?
      self.host.update(host: false)
    end
  end

end
