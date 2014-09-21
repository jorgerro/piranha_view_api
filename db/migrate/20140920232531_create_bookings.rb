class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
		  t.integer :timeslot_id
    	t.integer :size

      t.timestamps
    end
  end
end
