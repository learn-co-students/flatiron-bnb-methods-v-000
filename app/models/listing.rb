class Listing < ActiveRecord::Base
  belongs_to :neighborhood, required: true
  belongs_to :host, :class_name => "User"

  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true

  after_save :change_user_to_host
  before_destroy :revoke_host_status

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def self.available(start_date, end_date)
    if start_date && end_date
      joins(:reservations).
        where.not(reservations: {checkin: start_date..end_date}) &
      joins(:reservations).
        where.not(reservations: {checkout: start_date..end_date})
    else
      []
    end
  end

  def change_user_to_host
    unless self.host == true
      self.host.update(host: true)
    end
  end

  def revoke_host_status
    if self.host.listings.count <= 1
      self.host.update(host: false)
    end
  end
end
