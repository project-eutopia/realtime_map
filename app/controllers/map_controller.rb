class MapController < ApplicationController
  # Number of seconds of recent purchase data that should be
  # gotten on a first load, and subsequent calls
  FIRST_QUERY_LENGTH_IN_SECONDS = 20
  REGULAR_QUERY_LENGTH_IN_SECONDS = 20
  
  MAX_NUMBER_OF_PURCHASES_PER_CALL = 100
  
  def index
    @purchases = Purchase.recent(seconds: FIRST_QUERY_LENGTH_IN_SECONDS,
                                      limit: MAX_NUMBER_OF_PURCHASES_PER_CALL)

    respond_to do |format|
      format.html
    end
  end
  
  def query
    @purchases = Purchase.recent(seconds: REGULAR_QUERY_LENGTH_IN_SECONDS,
                                      limit: MAX_NUMBER_OF_PURCHASES_PER_CALL)
    
    respond_to do |format|
      format.json { render :json => @purchases.to_json }
    end

  end
end
