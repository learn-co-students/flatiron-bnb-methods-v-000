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

  before_save :host_status_true
  after_destroy :change_host_false

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def host_status_true
    host.update(host: true)
  end

  def change_host_false
    if host.listings.none?
      host.update(host: false)
    end
  end


end
