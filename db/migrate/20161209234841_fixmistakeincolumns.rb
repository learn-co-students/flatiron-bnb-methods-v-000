class Fixmistakeincolumns < ActiveRecord::Migration
  def change
    remove_column :reservations, :check_in
    remove_column :reservations, :check_out
    add_column :reservations, :checkin, :date
    add_column :reservations, :checkout, :date
  end
end
