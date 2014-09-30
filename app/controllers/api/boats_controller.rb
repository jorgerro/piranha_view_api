class Api::BoatsController < ApplicationController
  
  def create
    
    @boat = Boat.new(boat_params)

    if @boat.save
      render json: @boat
    else
      render json: @boat.errors, status: :unprocessable_entity
    end
    
  end
  
  def index
    @boats = Boat.all
    render json: @boats
  end
  
  private
  
    def boat_params
      params.require(:boat).permit(:name, :capacity)
    end
  
end
