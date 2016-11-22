class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :neighborhood, :price, presence: true

  after_create :host_true
  after_destroy :host_false

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def host_true
    unless host.host
      host.update(:host => true)
    end
  end

  def host_false
    if Listing.find_by(host_id: host.id).nil?
      host.update(:host => false)
    end
  end

end
