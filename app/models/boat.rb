class Boat < ActiveRecord::Base
  
  validates :name, presence: :true, uniqueness: :true
  validates :capacity, presence: :true
  
  has_many(
    :assignments,
    class_name: "Assignment",
    primary_key: :id,
    foreign_key: :boat_id,
    inverse_of: :boat,
    dependent: :destroy )
  
  has_many :timeslots, through: :assignments

end
