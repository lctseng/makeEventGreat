class Api::SearchController < ApplicationController

  protect_from_forgery except: :search_events
  before_action :add_allow_origin_header


  def search_events
    render json: Event.search_by_json(params)
  end
end
