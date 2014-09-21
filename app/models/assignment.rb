class Assignment < ActiveRecord::Base

  belongs_to(
    :timeslot,
    class_name: "Timeslot",
    foreign_key: :timeslot_id,
    primary_key: :id
  )
  
  belongs_to(
    :boat,
    class_name: "Boat",
    foreign_key: :boat_id,
    primary_key: :id
  )


end
