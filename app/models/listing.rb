class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  before_create :hostify_user
  before_destroy :dehostify_user

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  def average_review_rating
    ratings = reviews.collect { |review| review.rating }
    avg = ratings.inject(0, :+).to_f / ratings.count.to_f
  end

  private
    def hostify_user
      host.host = true
      host.save
    end

    def dehostify_user
      if host.listings.count == 1
        host.host = false
        host.save
      end
    end

end
