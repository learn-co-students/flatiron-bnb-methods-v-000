class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true



  private

  def host_status_change_to_true
    self.host.host = true
  end

  def host_status_change_to_false
    self.host.host = false 
  end

  end