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

  before_create :make_user_host_status_true
  before_destroy :make_user_host_status_false



  private

  def make_user_host_status_true
    host.update(host: true) unless host.host == true
  end

  def make_user_host_status_false
    host.update(host: false) if host.listings.count == 0
  end

end
