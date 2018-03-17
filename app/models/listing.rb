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

  after_create :make_creating_user_host
  before_destroy :remove_host_status_from_listingless_user

  def available?(start_date, end_date, res_id = nil)
    !reservations.where.not(id: res_id).detect{|r| (start_date-r.checkout).numerator <= 0 && (r.checkin-end_date).numerator <= 0}
  end

  def average_review_rating
    reviews.collect{|r| r.rating}.inject(0, :+).to_f / reviews.count
  end

  private

  def make_creating_user_host
    host.update(host: true)
  end

  def remove_host_status_from_listingless_user
    host.update(host: false) if host.listings.count == 1
  end
end
