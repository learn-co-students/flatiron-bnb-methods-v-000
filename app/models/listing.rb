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

  before_create :host_true
  # before_destroy :change_status

  # after_create :host_true
  after_destroy :change_status

  def host_true
    # this gives me even more errors than before with the previous creations
    # self.host.host = self.host.host


    self.host.host = true
    self.host.save
  end

  def change_status
    #this should change the status to host:true if the user has any listings
    #if all of them are destroyed, then change status host:false
    if self.host.listings.empty?
      self.host.host = false
      self.host.save
    else
      self.host.host = true
      self.host.save
    end
  end

  def average_review_rating
    x = 0.0
    count = 0
    self.reviews.each do |review|
      count += 1
      x = x + review.rating
    end
    # changed the count number to a float because as this scales, the count will typically be a lower number than x
    # x divided by count. The to_f (to float) so we can get the decimal point
    x / count
  end

  







end
