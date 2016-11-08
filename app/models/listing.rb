class Listing < ActiveRecord::Base
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true

  belongs_to :neighborhood, required: true
  belongs_to :host, :class_name => "User"

  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  after_save :set_host
  before_destroy :set_host_to_normal

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def self.available(start_date, end_date)
    if start_date && end_date
      joins(:reservations).where.not(reservations: {checkin: start_date..end_date}) &
      joins(:reservations).where.not(reservations: {checkout: start_date..end_date})
    else
      []
    end
  end

  def set_host_to_normal
    if Listing.where(host: host).where.not(id: id).empty?
      host.update(host:false)
    end
  end

  def set_host
    unless host == true
      host.update(host: true)
    end
  end
end
