class Api::SearchController < ApplicationController

  protect_from_forgery except: :search_events

  def search_events
    render json: event_params
    #render json: Event.search_by_json(event_params)
  end

  private
  
  def event_params
    params.permit(:keyword, :location, :date, :type, :host, :fee, :number_of_people)
  end

end
