class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  before_create :set_user_as_host
  after_destroy :unset_user_as_host

  def average_review_rating
    self.reviews.collect { |review|
      review.rating
    }.reduce(:+).to_f / self.reviews.count
  end

  private
    def set_user_as_host
      self.host.host = true
      self.host.save
    end

    def unset_user_as_host
      if self.host.listings.count < 1
        self.host.host = false
        self.host.save
      end
    end
end
