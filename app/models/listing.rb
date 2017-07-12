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

  after_save :host_status_set
  after_destroy :host_status_reset

  def average_review_rating
    all_reviews = self.reviews.collect do |review|
      review.rating
    end
    all_reviews.sum.to_f / all_reviews.count
  end

  private
    def host_status_set
      h = self.host
      h.host = true
      h.save
    end

    def host_status_reset
      h = self.host
      if !h.listings.any?
        h.host = false
      else
      end
      h.save
    end
end
