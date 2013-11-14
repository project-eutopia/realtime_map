class MapController < ApplicationController
  # Number of seconds of recent purchase data that should be
  # gotten on a first load, and subsequent calls
  FIRST_QUERY_LENGTH_IN_SECONDS = 20
  REGULAR_QUERY_LENGTH_IN_SECONDS = 20
  
  def index
    @purchases_json = Purchase.recent(FIRST_QUERY_LENGTH_IN_SECONDS).to_json

    respond_to do |format|
      format.html
      format.xml { render :xml => @people.to_xml }
    end
  end
end
