class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description,
                        :price, :neighborhood

  after_save :set_host_as_host
  before_destroy :unset_host_as_host


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

  def unset_host_as_host
    if Listing.where(host: host).where.not(id: id).empty?
      host.update(host: false)
    end
  end

  def set_host_as_host
    unless host.is_host?
      host.update(host: true)
    end
  end
end
