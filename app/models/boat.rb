class Boat < ActiveRecord::Base
  
  has_many(
    :assignments,
    class_name: "Assignment",
    primary_key: :id,
    foreign_key: :boat_id
    # inverse_of: :boat,
    # dependent_destroy: :true
  )



end
