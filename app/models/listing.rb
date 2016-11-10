class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_validation :make_host_true

  def average_review_rating
      self.reviews.sum(:rating)/self.reviews.count.to_f
  end

  private

  def make_host_true
      if self.host.present?
          self.host.host = true
      end
  end
end
