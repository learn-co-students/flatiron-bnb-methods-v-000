class Changecheckinandcheckout < ActiveRecord::Migration
  def change
    remove_column :reservations, :checkin
    remove_column :reservations, :checkout
    add_column :reservations, :check_in, :date
    add_column :reservations, :check_out, :date
  end
end
