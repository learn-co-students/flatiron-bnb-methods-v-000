class CreateJoinTable < ActiveRecord::Migration
  def change
  	create_table :joins do |t|
  		t.integer :listing_id
  		t.integer :host_id
  		t.integer :guest_id
  		t.integer :reservation_id
  	end
  end
end
