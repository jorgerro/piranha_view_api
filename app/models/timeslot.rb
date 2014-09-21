class Timeslot < ActiveRecord::Base
  
  has_many(
    :assignments,
    class_name: "Assignment",
    primary_key: :id,
    foreign_key: :timeslot_id
    # inverse_of: :timeslot,
    # dependent_destroy: :true
  )
  
  has_many(
    :bookings,
    class_name: "Booking",
    primary_key: :id,
    foreign_key: :timeslot_id
    # inverse_of: :timeslot,
    # dependent_destroy: :true
  )
  
  
  
  
end
