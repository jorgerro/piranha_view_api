class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
    	t.integer :timeslot_id
    	t.integer :boat_id

      t.timestamps
    end
  end
end
