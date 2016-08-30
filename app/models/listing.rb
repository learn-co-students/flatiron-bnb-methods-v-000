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
  validates :neighborhood_id, presence: true

  before_create :change_host_status
<<<<<<< HEAD
  around_destroy :change_host_status, if: :all_gone?

  def average_review_rating()
    self.reservations.inject(0) {|sum, r| sum + r.review.rating} / self.reservations.count.to_f
  end
=======
  after_destroy :change_host_status, if: :all_gone?
>>>>>>> aa2630f1539d30064607188aa771c86207f72366

  protected
  def change_host_status
    self.host.host = !self.host.host
    self.host.save
  end

  def all_gone?
<<<<<<< HEAD
    self.host.listings.count == 1
=======
    self.host.listings.empty?
>>>>>>> aa2630f1539d30064607188aa771c86207f72366
  end


end
