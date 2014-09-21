class Booking < ActiveRecord::Base
  
  belongs_to(
    :timeslot,
    class_name: "Timeslot",
    foreign_key: :timeslot_id,
    primary_key: :id
  )
  
end
