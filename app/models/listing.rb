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

  after_save :make_host_true
  after_destroy :change_host_status_to_false_if_all_associated_listings_destroyed

  def average_review_rating
    if !self.reviews.empty?
      sum_reviews = self.reviews.reduce(0) { |sum, n| sum + n.rating }
      num_reviews = self.reviews.count

      sum_reviews.to_f / num_reviews.to_f
    end
  end

  private

  def make_host_true
    self.host.update(host: true)
  end

  def change_host_status_to_false_if_all_associated_listings_destroyed
    if self.host.listings.count == 0
      self.host.update(host: false)
    end
  end
end