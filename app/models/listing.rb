class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood, :host, presence: true

  before_save :toggle_user_host_status

  private

  def toggle_user_host_status
    self.host.host = true if self.host.host == false
    self.host.save
  end
end
