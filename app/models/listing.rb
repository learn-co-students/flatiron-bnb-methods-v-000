class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :title, :description, :price, :neighborhood, :listing_type, presence: true

  def average_review_rating
    self.reviews.average(:rating)
  end

  after_save do
    host.update(host: true)
  end

  after_destroy do
    if host.listings.empty?
      host.update(host: false)
    end
  end

end
