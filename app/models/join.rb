class Join < ActiveRecord::Base
	belongs_to :host, :class_name => "User", :foreign_key => "host_id"
	belongs_to :guest, :class_name => "User", :foreign_key => "guest_id"
	belongs_to :listing
	belongs_to :reservation
end