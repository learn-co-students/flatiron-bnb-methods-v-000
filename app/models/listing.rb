class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_save :set_host_to_user
  before_destroy :unset_host_from_user

  def available?(starts_at, ends_at)
    !self.reservations.any? do |reserv|
      (starts_at < reserv.checkout) && (ends_at > reserv.checkin)
    end
  end

  def average_review_rating
    av = self.reviews.reduce(0) { |sum, review| sum + review.rating }
    av = av.to_f/self.reviews.size
  end

  private

    def set_host_to_user
      if self.host
        host.update(host: true)
      end
    end

    def unset_host_from_user
      if self.host && self.host.listings.where.not(id: self.id).empty?
        host.update(host: false)
      end
    end
end
