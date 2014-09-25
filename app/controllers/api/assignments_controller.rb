class Api::AssignmentsController < ApplicationController
  
  def create
    
    @assignment = Assignment.new(assignment_params)

    if @assignment.save
      render json: @assignment
    else
      # head :bad_request
      render json: @assignment.errors, status: :unprocessable_entity
    end
    
  end
  
  private
  
    def assignment_params
      params.require(:assignment).permit(:timeslot_id, :boat_id)
    end
  
end
