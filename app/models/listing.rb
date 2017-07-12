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

  before_create :change_host_to_true
  after_destroy :change_host_to_false


  def average_review_rating
    self.reviews.average("rating")
  end


  private

   def change_host_to_true
    self.host.update(host: true)
   end

   def change_host_to_false
    if self.host.listings.empty?
      self.host.update(host: false)
    end
   end


end
