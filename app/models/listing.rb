class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_create :host_true

  after_destroy :host_false

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def host_true
    @user = User.find_by_id(self.host_id)
    @user.host = true
    @user.save
  end

  def host_false
    @user = User.find_by_id(self.host_id)
    if @user.listings.count == 0
      @user.host = false
      @user.save
    end
  end

end
