class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, class_name: "User"
  has_many :reservations
  has_many :reviews, through: :reservations
  has_many :guests, class_name: "User", through: :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_save :change_host_status
 after_destroy :revert_host_status

  def average_review_rating
    ratings = []
    reviews.each {|r| ratings << r.rating}

    ratings.reduce(:+) / ratings.size.to_f
  end

  def change_host_status
     self.host.update(host: true)
  end

  def revert_host_status
    self.host.update(host: false) if self.host.listings.empty?
  end

end
