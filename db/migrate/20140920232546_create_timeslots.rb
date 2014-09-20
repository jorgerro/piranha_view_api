class CreateTimeslots < ActiveRecord::Migration
  def change
    create_table :timeslots do |t|
    	t.integer :start_time
    	t.integer :duration
    	
      t.timestamps
    end
  end
end
